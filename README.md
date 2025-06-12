# nashville-housing-data-cleaning-sql
## Objective
To clean, standardize, and transform a real-world housing dataset using SQL so that it becomes suitable for further analysis or visualization in tools like Power BI or Tableau.

---

## Tools & Skills Used
- MySQL
- String Functions: `SUBSTRING_INDEX`, `TRIM`, `LOCATE`
- Window Functions: `ROW_NUMBER()`
- Conditional Logic: `CASE`
- Data Formatting: `STR_TO_DATE()`
- Joins & Self Joins
- Table Alterations & Updates
- Duplicate Removal

---

## Dataset Description
- A public dataset containing Nashville housing sales data.
- Contains fields such as Parcel ID, Sale Date, Address, Owner Address, Legal Reference, etc.

---

## Data Cleaning Steps Performed

### 1.Date Standardization
- Converted `SaleDate` from string format to MySQL’s `DATE` format using `STR_TO_DATE()`.

### 2.Handling Missing Property Addresses
- Used **self-joins** to fill missing `PropertyAddress` values based on matching `ParcelID` from other rows.

### 3.Address Normalization
- Split both `PropertyAddress` and `OwnerAddress` into separate fields: **Street Number**, **Street Name**, **City**, and **State** using combinations of `SUBSTRING_INDEX`, `LOCATE`, and `TRIM`.

### 4.Column Value Cleanup
- Cleaned the `SoldAsVacant` column by replacing `"Y"` and `"N"` with `"Yes"` and `"No"` using `CASE WHEN`.

### 5.Duplicate Row Removal
- Added a `Unique_id` column and used `ROW_NUMBER()` to identify and delete duplicate records based on `ParcelID`, `SaleDate`, `SalePrice`, and `LegalReference`.

### 6.Dropping Unused Columns
- Dropped columns like `PropertyAddress`, `TaxDistrict`, `OwnerAddress`, and `SaleDate` once they were cleaned or replaced.

## 📬 Let's Connect!
If you're a recruiter or someone interested in collaborating, feel free to reach out or connect with me on [LinkedIn](https://www.linkedin.com/in/sulemantheanalyst).  
