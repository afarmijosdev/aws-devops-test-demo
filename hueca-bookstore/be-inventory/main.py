import os

import pymssql
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Bookstore Inventory Backend")


class Book(BaseModel):
    id: int
    title: str
    author: str
    price: float
    stock: int
    available: bool


DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "1433"))
DB_NAME = os.getenv("DB_NAME", "hueca_bookstore")
DB_USER = os.getenv("DB_USER", "db_api")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")

BOOKS_QUERY = """
    SELECT id, title, author, price, stock, available
    FROM hueca_bookstore.books
    ORDER BY id
"""


def fetch_books() -> list[Book]:
    with pymssql.connect(
        server=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        login_timeout=5,
        timeout=10,
        as_dict=True,
    ) as conn:
        with conn.cursor() as cursor:
            cursor.execute(BOOKS_QUERY)
            return [Book.model_validate(row) for row in cursor.fetchall()]


@app.get("/")
async def hello_world() -> dict[str, str]:
    return {"message": "Hello World from the inventory backend"}


@app.get("/api/books", response_model=list[Book], operation_id="getBackendBooks")
def get_books() -> list[Book]:
    try:
        return fetch_books()
    except pymssql.Error as exc:
        raise HTTPException(
            status_code=503,
            detail="The inventory database is not available.",
        ) from exc
