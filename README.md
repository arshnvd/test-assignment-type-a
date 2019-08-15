# Solution 

Solution is mainly focused on best approach and code quality, a few things are skipped for simplicity.
1. There is only one `docker-compose.yml`.
2. User authentication is not implemented.

### What can be improved
1. right now most of the processing logic is inside `app/models/invoice/bulk_upload.rb` we can move it into a separate *service*.
2. we can use a background job to relay ActionCable broadcast messages so that they are enqueued and delivered accurately in correct order.
3. more test coverage, currently there are only model tests.

> NOTE for invoice *internal id*, to avoid confusion with ActiveRecord's *id* an `internal_id` column is added separately as a integer and it is assumed that it must be an integer not string.
> also there is a sample-data.csv file for sample data (in case needed).

### Overview

At high-level when a CSV file is submitted via bulk upload page, it should be uploaded to cloud storage via direct upload (currently it's just local storage but can be changed in `storage.yml` make sure to configure CORS properly for your cloud provider).
Once uploaded a database record is created, after creation a background job is triggered which downloads the file from cloud (as a temporary file) processes the CSV (creates invoices, selling price is calculated on before create invoice) and updates the progress bar in real time.

#### Screenshots

*Upload*
![Screenshot 2019-08-15 at 11 02 13 PM](https://user-images.githubusercontent.com/18441501/63115724-4046a900-bfb1-11e9-974f-0023dd43a5d2.png)

*All Uploads*
<img width="1406" alt="Screenshot 2019-08-15 at 11 17 11 PM" src="https://user-images.githubusercontent.com/18441501/63116366-e515b600-bfb2-11e9-9e96-7c40bb6a6b46.png">

*View upload report*
<img width="1337" alt="Screenshot 2019-08-15 at 11 17 30 PM" src="https://user-images.githubusercontent.com/18441501/63116377-eba42d80-bfb2-11e9-9ede-606088c422c2.png">

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

# Feature: Invoice upload

As a customer, I would like to upload files and get converted them into Invoices with precalculation.

1. A customer prepares CSV file with invoices: the first column is internal invoice id, the second is invoice amount and "due on" date

```
1,100,2019-05-20
2,200.5,2019-05-10
B,300,2019-05-01
```

The real-life file includes five thousand rows and includes invalid rows.

2. Customer can upload invoice CSV to the system
3. System processes file so that every invoice gets the selling price according to the next logic:
> Invoice sell price depends on amount and days to the due date. The formula is `amount * coefficient`. The coefficient is 0.5 when the invoice uploaded more than 30 days before the due date and 0.3 when less or equal to 30 days.

3. Customer can check invoices uploaded to the system and check their selling price.
4. Customer can get upload report and understand errors related to CSV file row processing.
