use PortfolioProject;
DESCRIBE `nashville housing data for data cleaning (reuploaded)`;
select * from `nashville housing data for data cleaning (reuploaded)`;

-- Standardize Date Format 
select SaleDate from `nashville housing data for data cleaning (reuploaded)`;
create table `nashville housing data for data cleaning (reuploaded)_copied`
like `nashville housing data for data cleaning (reuploaded)`;
Insert `nashville housing data for data cleaning (reuploaded)_copied`
select * from `nashville housing data for data cleaning (reuploaded)`;
select * from `nashville housing data for data cleaning (reuploaded)_copied`;

Alter table `nashville housing data for data cleaning (reuploaded)_copied`
Add column NewSaleDate Date;
Update `nashville housing data for data cleaning (reuploaded)_copied`
set NewSaleDate = str_to_date(SaleDate,'%M %d, %Y');
select NewSaleDate , str_to_date(SaleDate,'%M %d, %Y') ParsedDate
from `nashville housing data for data cleaning (reuploaded)_copied`;
select * from `nashville housing data for data cleaning (reuploaded)_copied`;

-- Populate property address data 
select * from `nashville housing data for data cleaning (reuploaded)_copied`
where PropertyAddress is null or PropertyAddress = '';
update `nashville housing data for data cleaning (reuploaded)_copied`
set PropertyAddress = Null 
where PropertyAddress = '';
select * from `nashville housing data for data cleaning (reuploaded)_copied`
order by ParcelID;

select A.ParcelID,A.PropertyAddress,B.ParcelID, B.PropertyAddress
from `nashville housing data for data cleaning (reuploaded)_copied` A
join `nashville housing data for data cleaning (reuploaded)_copied` B 
on A.ParcelID = B.ParcelID And 
   A.﻿UniqueID !=  B.﻿UniqueID 
where A.PropertyAddress is null;

-- Now update and populate data 
Update `nashville housing data for data cleaning (reuploaded)_copied` A
join `nashville housing data for data cleaning (reuploaded)_copied` B 
on A.ParcelID = B.ParcelID And 
   A.﻿UniqueID !=  B.﻿UniqueID 
set A.PropertyAddress = B.PropertyAddress   
where A.PropertyAddress is null;


-- Breaking out Address into individual columns(Address, City, State)
-- This way u cannot get the middle word correctly 
select PropertyAddress
from `nashville housing data for data cleaning (reuploaded)_copied`;
select PropertyAddress,SUBSTRING_INDEX(PropertyAddress, ' ',1) Street_Number,
SUBSTRING_INDEX(Substring_Index(PropertyAddress, ',',2),',',-1) Street_Name,
SUBSTRING_INDEX(PropertyAddress, ',',-1) City
from `nashville housing data for data cleaning (reuploaded)_copied`;


-- This one is the static approach and can change it manually like here we need last three words so we use -3 in inner substring 
SELECT PropertyAddress,
SUBSTRING_INDEX(PropertyAddress, ' ', 1) AS StreetNumber,
TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(PropertyAddress, ',', 1),' ', -3)) AS StreetName,
TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
FROM `nashville housing data for data cleaning (reuploaded)_copied`;

-- This one is the dynamic approach by using locate() and it will work well if you need to find one comma 
SELECT PropertyAddress,
  -- Get first word before the first space
SUBSTRING_INDEX(PropertyAddress, ' ', 1) AS StreetNumber,
  -- Get everything between the first space and the comma
  TRIM(SUBSTRING(PropertyAddress,
      LOCATE(' ', PropertyAddress) + 1,LOCATE(',', PropertyAddress) - LOCATE(' ', PropertyAddress) - 1)) AS StreetName,
  -- Get everything after the comma
  TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
FROM `nashville housing data for data cleaning (reuploaded)_copied`;

-- Now Update the table 
Alter table `nashville housing data for data cleaning (reuploaded)_copied`
Add column PropertyStreetNumber nvarchar(255);
Update `nashville housing data for data cleaning (reuploaded)_copied`
set PropertyStreetNumber = SUBSTRING_INDEX(PropertyAddress, ' ', 1);
Alter table `nashville housing data for data cleaning (reuploaded)_copied`
Add column PropertyStreetName nvarchar(255);
Update `nashville housing data for data cleaning (reuploaded)_copied`
set PropertyStreetName = TRIM(SUBSTRING(PropertyAddress,
      LOCATE(' ', PropertyAddress) + 1,
      LOCATE(',', PropertyAddress) - LOCATE(' ', PropertyAddress) - 1));
Alter table `nashville housing data for data cleaning (reuploaded)_copied`
Add column PropertyCity nvarchar(255);
Update `nashville housing data for data cleaning (reuploaded)_copied`
set PropertyCity = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));
select * from `nashville housing data for data cleaning (reuploaded)_copied`;

-- Now breakdown the another address into (Adddress, City and State)
-- This locate() will not work property and not suitable to use when you need to find more than one comma thats why its not giving the accurate result 
select OwnerAddress from `nashville housing data for data cleaning (reuploaded)_copied`;
select OwnerAddress,
substring_index(OwnerAddress,',',1) As Address,
Trim(Substring(OwnerAddress,
		Locate(',' , OwnerAddress) +1, Locate(',', OwnerAddress) - Locate(',',OwnerAddress) -1 )) As City,
Trim(Substring_index(OwnerAddress,',', -1)) as State    
from `nashville housing data for data cleaning (reuploaded)_copied`;

-- Here substring_index will work properly or you can also use advance locate but i am using substring_index because its more cleaner and safe for extracting 
select OwnerAddress,
Trim(substring_index(OwnerAddress,',',1)) as Address,
Trim(substring_index(substring_index(OwnerAddress,',',2),',', -1)) as City,
Trim(substring_index(OwnerAddress,',',-1)) as State
from `nashville housing data for data cleaning (reuploaded)_copied`;
-- Now update the table 
Alter table `nashville housing data for data cleaning (reuploaded)_copied`
Add Column Address nvarchar(255);
update `nashville housing data for data cleaning (reuploaded)_copied`
set Address = Trim(substring_index(OwnerAddress,',',1)) ;
Alter table `nashville housing data for data cleaning (reuploaded)_copied`
Add Column City nvarchar(255);
update `nashville housing data for data cleaning (reuploaded)_copied`
set City = Trim(substring_index(substring_index(OwnerAddress,',',2),',', -1));
Alter table `nashville housing data for data cleaning (reuploaded)_copied`
Add Column State nvarchar(255);
update `nashville housing data for data cleaning (reuploaded)_copied`
set State = Trim(substring_index(OwnerAddress,',',-1));
select * from `nashville housing data for data cleaning (reuploaded)_copied`;
-- Just change the coulumn name to make it clear that where it belong 
Alter table `nashville housing data for data cleaning (reuploaded)_copied`
Change Address OwnerSplitAddress varchar(255),
Change City OwnerCity varchar(255),
Change State OwnerState varchar(255);


-- Change N to No and Y to Yes from SoldAsVacant column 
select Distinct SoldAsVacant , count(SoldAsVacant)
from `nashville housing data for data cleaning (reuploaded)_copied`
group by SoldAsVacant
order by 2;
select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
End
from `nashville housing data for data cleaning (reuploaded)_copied`;  
-- Now update the table 
update `nashville housing data for data cleaning (reuploaded)_copied`
set SoldAsVacant =   Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
End;
-- Remove duplicates 
-- Before removing duplicates we need to add unique_id because its not showing 
-- Give each row a unique identifier so you can use ROW_NUMBER() logic safely.
ALTER TABLE `nashville housing data for data cleaning (reuploaded)_copied`
ADD COLUMN Unique_id INT AUTO_INCREMENT PRIMARY KEY;
-- you cannot delete directly from a CTE (Common Table Expression) in MySQL — it's read-only.
select * from `nashville housing data for data cleaning (reuploaded)_copied`;
with RowNumCte as (
select *, 
row_number() over (
partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference
order by Unique_id
) row_num
from `nashville housing data for data cleaning (reuploaded)_copied`
)
Delete from RowNumCte
where row_num > 1;
-- Always test first with a SELECT before deleting:To ensure that you are about to delete these rows 
SELECT * FROM (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
           ORDER BY Unique_id
         ) AS row_num
  FROM `nashville housing data for data cleaning (reuploaded)_copied`
) AS sub
WHERE row_num > 1;
-- You need to delete from the original table by using the ROW_NUMBER() logic in a subquery not by using cte, like this:
DELETE FROM `nashville housing data for data cleaning (reuploaded)_copied`
WHERE Unique_id IN (
  SELECT Unique_id FROM (
    SELECT Unique_id,
           ROW_NUMBER() OVER (
             PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
             ORDER BY Unique_id
           ) AS row_num
    FROM `nashville housing data for data cleaning (reuploaded)_copied`
  ) AS subquery
  WHERE row_num > 1
);

-- Delete unused columns 
select * from `nashville housing data for data cleaning (reuploaded)_copied`;
ALTER TABLE `nashville housing data for data cleaning (reuploaded)_copied` 
DROP COLUMN PropertyAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN OwnerAddress,
DROP COLUMN SaleDate;










   