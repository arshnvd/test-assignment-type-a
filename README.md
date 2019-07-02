# Test assignment: Type A

This is a test assignment. We have developed a simple assignment to imitate real system situation. Test assignment should show the candidate ability to system thinking, coding style, and code versioning skills.

Test assignment consists of two parts. First looks like README and guides you through infrastructure part to build. Second, described one feature to implement.

### Pre-requirements

- Ruby on Rails framework experience
- Minitest as a testing framework
- Front-end level basic JavsScript experience
- Docker infrastructure experience

-----------------------------------------

# Getting started

TypeA uses docker for simplifying deployment, development, and test process. So you should install docker and docker-compose first.

# Installation

TypeA project running on ruby 2.6 docker image.

First, you have to build an image:

```
docker build supplierplus/type-a
```

Second, you have to set `.env` file according to your preferences

Third, setup database.

```
docker-compose run --rm app rails db:setup
docker-compose run --rm app rails db:seed
```

Finally, run:

```
docker-compose up -d
```

You can select a current user on login; for simplicity reason, there are no requirements to authentication.

# Development

```
Dev setup:
docker-compose -f docker-compose.development.yml run --rm app bundle
docker-compose -f docker-compose.development.yml run --rm app rails db:setup

Dev run:
docker-compose -f docker-compose.development.yml up
```

# Test

```
Test setup:
docker-compose -f docker-compose.test.yml run --rm app bundle install --without development
docker-compose -f docker-compose.test.yml run --rm app rails db:setup

Dev run:
docker-compose -f docker-compose.test.yml rails test
```

--------------------------------------------

# Feature Upload

As a customer, I would like to upload files and get converted them into Invoices with precalculation.

1. A customer prepares CSV file with invoices: the first column is internal invoice id, the second is invoice amount

```
1,100
2,200.5
B,300
```

2. Customer can upload invoice CSV to the system
3. System processes file so that every invoice gets the selling price according to the next logic:
> Invoices with an amount less than 200 gets selling price of `amount * 0.5`, invoices with amount more or equal to 200 gets selling price `amount * 0.3`

3. Customer can check invoices uploaded to the system and check their selling price.