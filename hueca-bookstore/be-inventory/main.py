from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Bookstore Inventory Backend")


class Book(BaseModel):
    id: int
    title: str
    author: str
    price: float
    stock: int
    available: bool


FAKE_BOOKS = [
    Book(
        id=1,
        title="The Pragmatic Programmer",
        author="Andrew Hunt",
        price=49.99,
        stock=12,
        available=True,
    ),
    Book(
        id=2,
        title="Clean Code",
        author="Robert C. Martin",
        price=39.99,
        stock=8,
        available=True,
    ),
    Book(
        id=3,
        title="Automate the Boring Stuff with Python",
        author="Al Sweigart",
        price=29.99,
        stock=0,
        available=False,
    ),
]


@app.get("/")
async def hello_world() -> dict[str, str]:
    return {"message": "Hello World from the inventory backend"}


@app.get("/api/books", response_model=list[Book], operation_id="getBackendBooks")
async def get_books() -> list[Book]:
    return FAKE_BOOKS
