
## Column Mapping

### Dim_term_code
source : table Acquisition

target : table dim_term_code

| Source Column  | Target Column  | Transformation                                     |
|----------------|----------------|----------------------------------------------------|
| uuid generated | `term_code_id` |----------------------------------------------------|
| `term_code`    | `term_code`    |----------------------------------------------------|

### Dim_stock_symbol
source : table Ipos

target : table dim_stock_symbol

| Source Column  | Target Column     | Transformation                                     |
|----------------|----------------   |----------------------------------------------------|
| uuid generated | `stock_symbol_id` |----------------------------------------------------|
| `stock_symbol` | `stock_symbol`    |----------------------------------------------------|



### Dim Company
source : Company

target : table dim_company
| Source Column   | Target Column   |Transformation |
|---------------- |---------------- |---------------|
| uuid generated  | `company_id`    |generated  uuid|
| `office_id`     | `company_nk_id` |---------------|
| `object_id`     | `object_id`     |---------------|
| `description`   | `description`   |---------------|
| `region`        | `region`        |---------------|
| `address1`      | `address1`      |---------------|
| `address2`      | `address2`      |---------------|
| `city`          | `city`          |---------------|
| `zip_code`      | `zip_code`      |---------------|
| `state_code`    | `state_code`    |---------------|
| `country_code`  | `country_code`  |---------------|
| `latitude`      | `latitude`      |---------------|
| `longitude`     | `longitude`     |---------------|
| `created_at`    | `created_at`    |---------------|
| `updated_at`    | `updated_at`    |---------------|


### Fact Acquisition Table
source : table acquisition, dim_term_code, dim_company, dim_date

target : table fct_acquisition
| Source Column              | Target Column                | Transformation                                      |
|----------------------------|----------------------------- |---------------------------------------------------- |
| uuid generated             | `acquisition_id`             | -                                                   |
| `acquisition_id`           | `acquisition_nk_id`          | -                                                   |
| `acquiring_object_id`,`company_id`| `acquiring_object_id`  | lookup to company_id based on acquiring_object_id  |
| `acquired_object_id` ,`company_id`| `acquired_object_id`   | lookup to company_id based on acquired_object_id   |
| `term_code_id`,`term_code`        | `term_code_id`         |  lookup to term_code_id based on  term_code        |
| `"price_amount"`                  | `"price_amount"`       | -                                                  |
| `prince_currency_code`            | `prince_currency_code` | -                                                  |
| `acquired_at`, `date_id`          | `acquired_at`          | lookup to date_id based on acquired_at             |
| `source_url`                      | `source_url`           | -                                                  |
| `source_description`              | `source_description`   | -                                                  |
| `created_at`               | `created_at`                  | -                                                  |
| `updated_at`               | `updated_at`                  | -                                                  |

### Fact Funds Table
source : table funds, dim_date, dim_company

target : table fct_acquisition
| Source Column              | Target Column                | Transformation                                      |
|----------------------------|----------------------------- |---------------------------------------------------- |
| uuid generated             | `fund_id`             | -                                                   |
| `fund_id`                  | `fund_nk_id`          | -                                                   |
| `object_id`                | `object_id`           | lookup to company_id based on object_id             |
| `"name"`                   | `"name"`              | -                                                  |
| `funded_at`, `date_id`     | `funded_at`           | lookup to date_id based on funded_at               |
| `source_url`               | `source_url`          | -                                                  |
| `"raise_amount"`           | `"raise_amount"`      | -                                                  |
| `raise_currency_code`      | `raise_currency_code` | -                                                  |
| `source_description`       | `source_description`  | -                                                  |
| `created_at`               | `created_at`          | -                                                  |
| `updated_at`               | `updated_at`          | -                                                  |


### Fact Funds Table
source : table acquisition, dim_term_code, dim_company
target : table fct_acquisition
| Source Column              | Target Column                | Transformation                                      |
|----------------------------|----------------------------- |---------------------------------------------------- |
| uuid generated             | `acquisition_id`             | -                                                   |
| `acquisition_id`           | `acquisition_nk_id`          | -                                                   |
| `acquiring_object_id`,`company_id`| `acquiring_object_id`  | lookup to company_id based on acquiring_object_id  |
| `acquired_object_id` ,`company_id`| `acquired_object_id`   | lookup to company_id based on acquired_object_id   |
| `term_code_id`,`term_code`        | `term_code_id`         |  lookup to term_code_id based on  term_code        |
| `"price_amount"`                  | `"price_amount"`       | -                                                  |
| `prince_currency_code`            | `prince_currency_code` | -                                                  |
| `acquired_at`, `date_id`          | `acquired_at`          | lookup to date_id based on acquired_at             |
| `source_url`                      | `source_url`                      | - |
| `source_description`              | `source_description`                   | - |
| `"created_at"`                    | `"created_at"`                     | - |
| `"updated_at"`                    | `"updated_at"`                   | - |
| `duration`                    | `duration`                  | - |
| `duration`                 | `duration_in_year`          | duration divide by `365`, round down, and cast to `INT` |
| `campaign`                 | `campaign`                  | - |
| `pdays`                    | `days_since_last_campaign`  | Rename column |
| `previous`                 | `previous_campaign_contacts`| Rename column |
| `poutcome`                 | `previous_campaign_outcome` | Rename column |
| `subscribed_deposit`       | `subscribed_deposit`        | - |
| `created_at`               | `created_at`                | - |
| `updated_at`               | `updated_at`                | - |

### Customers
source : file new_bank_transaction.csv

target : table customers

| Source Column          | Target Column      | Transformation                                      |
|------------------------|-------------------|----------------------------------------------------|
| `CustomerID`          | `customer_id`      | Rename column |
| `CustomerDOB`         | `birth_date`       | Convert to `DATE` format (`d/M/yy`), adjust years if > 2025 |
| `CustGender`          | `gender`           | Rename column; Map `M` → `Male`, `F` → `Female`, others → `Other` |
| `CustLocation`        | `location`         | Rename column |
| `CustAccountBalance`  | `account_balance`  | Rename column, cast to decimal number |

### Transactions
source : file new_bank_transaction.csv

target : table transactions

| Source Column                 | Target Column      | Transformation                                                   |
|--------------------------------|-------------------|-----------------------------------------------------------------|
| `TransactionID`               | `transaction_id`  | Rename column |
| `CustomerID`                  | `customer_id`     | Rename column |
| `TransactionDate`             | `transaction_date` | Convert to `DATE` format (`d/M/yy`), adjust years if > 2025 |
| `TransactionTime`             | `transaction_time` | Convert to `HH:MM:SS` format |
| `TransactionAmount (INR)`     | `transaction_amount` | Rename column, cast to decimal number |
