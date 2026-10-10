from html import escape
import os

import httpx
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from pydantic import BaseModel

app = FastAPI(title="Bookstore Inventory Frontend")
BACKEND_API_URL = os.getenv("BACKEND_API_URL", "http://localhost:8001").rstrip("/")


class Book(BaseModel):
    id: int
    title: str
    author: str
    price: float
    stock: int
    available: bool


@app.get("/api/books", response_model=list[Book], operation_id="getAvailableBooks")
async def get_available_books() -> list[Book]:
    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            response = await client.get(f"{BACKEND_API_URL}/api/books")
            response.raise_for_status()
    except httpx.HTTPError as exc:
        raise HTTPException(
            status_code=502,
            detail="The inventory backend could not provide available books.",
        ) from exc

    return [Book.model_validate(book) for book in response.json()]


@app.get("/", response_class=HTMLResponse)
async def inventory_page() -> HTMLResponse:
    books = await get_available_books()
    rows = "".join(
        "<tr>"
        f"<td>{escape(book.title)}</td>"
        f"<td>{escape(book.author)}</td>"
        f"<td>${book.price:.2f}</td>"
        f"<td>{book.stock}</td>"
        "</tr>"
        for book in books
    )
    return HTMLResponse(
        "<!doctype html>"
        '<html lang="en"><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width, initial-scale=1">'
        "<title>Bookstore Inventory</title>"
        "<style>"
        "body{font-family:system-ui,sans-serif;margin:2rem;color:#222}"
        "table{border-collapse:collapse;width:100%;max-width:800px}"
        "th,td{border:1px solid #ccc;padding:.65rem;text-align:left}"
        "th{background:#f2f2f2}"
        "</style></head><body>"
        "<h1>Bookstore Inventory</h1>"
        "<table><thead><tr><th>Book</th><th>Author</th>"
        "<th>Price</th><th>Stock</th></tr></thead>"
        f"<tbody>{rows}</tbody></table></body></html>"
    )
