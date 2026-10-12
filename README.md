# aws-devops-test-demo

## Objective
Resolve the Epic User story using IaC.

## User Story

As a collector of ecuadorian dishes recipes gathered from small restaurants (huecas) and books, I want to show my recipes list so that everyone in the internet can contact to me share with me after a trade (buy-sell,rent). 

Acceptance Criteria

Given a site recipe list link, 
when clic on that link
Then I would see the title, author, price, stock and available of  my books and recipe list; and the contact email. 


## Tasks to solve the User Story

### Phase 1

- Deploy Hueca bookstore app
  - Deploy the infrastructure
    - Deploy vpc
    - Deploy EKS with helm
    - Deploy the ECR
  - Deploy the webapp
    - Create two apis that say hello world    
      * fe-inventory (front end)
      * be-inventory (back end)
    - Update the APIs to show a list of mock books
    - Generate the Docker Images
      - Create Github action to push the ECR
  
### Phase 2

- Deploy Hueca bookstore app
  - Deploy the infrastructure
    - Deploy the RDS instance
    - Deploy the flyway service (db-migration)
      - Github action to create the db-migration EKS job and run SQL script.  
  - Deploy the webapp
    - Update the be-inventory to:
      - Read the list from a database 
    - Generate the SQL Scripts to:
      - Provision the database tables
      - Push the list of books and recipes inventory
      - Github action to push flyway and scripts ECR
    - Update the APIs to show a list of mock books
    - Generate the Docker Images
      - Create Github action to push the ECR


## Mock bookstore inventory APIs

Both services return fake data and do not persist anything.

Install the Python dependencies from `hueca-bookstore/requirements.txt`, then
run each service from the repository root in a separate terminal:

```bash
uvicorn main:app --app-dir hueca-bookstore/be-inventory --reload --port 8001
uvicorn main:app --app-dir hueca-bookstore/fe-inventory --reload --port 8000
```

The backend serves its fake catalog, including price and stock counts, at
`GET http://localhost:8001/api/books`. The frontend displays the catalog as a
table at `http://localhost:8000/` and serves the same data at
`GET http://localhost:8000/api/books`. Configure `BACKEND_API_URL` if the
backend is at a different address.
  