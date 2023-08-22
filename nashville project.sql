
select *
from hussainportforlio.dbo.nasvillehousing

--standardize date format
select SaleDate, convert(date, SaleDate) 
from hussainportforlio.dbo.nasvillehousing

alter table nasvillehousing
add Salesdateconverted date

update nasvillehousing
set Salesdateconverted = convert(date, SaleDate) 

select Salesdateconverted
from hussainportforlio.dbo.nasvillehousing

-- populate property address 
select *
from hussainportforlio.dbo.nasvillehousing
--where PropertyAddress is null
order by  ParcelID

select nav.ParcelID, nav.PropertyAddress,nab.ParcelID, nab.PropertyAddress, isnull(nav.PropertyAddress, nab.PropertyAddress)
from hussainportforlio.dbo.nasvillehousing as nav
join hussainportforlio.dbo.nasvillehousing as nab
	on nav.ParcelID = nab.ParcelID
	and nav.[UniqueID ] <> nab.[UniqueID ]
where nav.PropertyAddress is  null

update nav
set PropertyAddress = isnull(nav.PropertyAddress, nab.PropertyAddress)
from hussainportforlio.dbo.nasvillehousing as nav
join hussainportforlio.dbo.nasvillehousing as nab
	on nav.ParcelID = nab.ParcelID
	and nav.[UniqueID ] <> nab.[UniqueID ]
	
--breaking out address, into individual column (addrees city, state

select PropertyAddress
from hussainportforlio.dbo.nasvillehousing

select
SUBSTRING(PropertyAddress, 1, charindex(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1, LEN(PropertyAddress)) as Addresscity
from hussainportforlio.dbo.nasvillehousing

alter table nasvillehousing
add propertyspitadddree Nvarchar(255)

alter table nasvillehousing
add propertyspitcity Nvarchar(255)

update nasvillehousing
set propertyspitadddree = SUBSTRING(PropertyAddress, 1, charindex(',',PropertyAddress)-1) 

update nasvillehousing
set propertyspitcity = SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1, LEN(PropertyAddress))

select*
from hussainportforlio.dbo.nasvillehousing


--breaking out owners address

select OwnerAddress
from hussainportforlio.dbo.nasvillehousing

select 
PARSENAME (replace (OwnerAddress, ',', '.'),3) as ownerAddress
,PARSENAME (replace (OwnerAddress, ',', '.'),2) as ownnerCity
,PARSENAME (replace (OwnerAddress, ',', '.'),1) as Ownerstate
from hussainportforlio.dbo.nasvillehousing

alter  table nasvillehousing
add OwnerAdress nvarchar(255)

alter  table nasvillehousing
add OwnerCity nvarchar(255)

alter  table nasvillehousing
add Ownerstate nvarchar(255)


update nasvillehousing
set OwnerAdress = PARSENAME (replace (OwnerAddress, ',', '.'),3) 

update nasvillehousing
set OwnerCity = PARSENAME (replace (OwnerAddress, ',', '.'),2) 

update nasvillehousing
set Ownerstate = PARSENAME (replace (OwnerAddress, ',', '.'),1) 

select*
from hussainportforlio.dbo.nasvillehousing


--chnge y and N and no in "sold as vacant" field

select distinct SoldAsVacant, count(SoldAsVacant) as a
from hussainportforlio.dbo.nasvillehousing
group by SoldAsVacant
order by a

select distinct SoldAsVacant,
case
	when SoldAsVacant = 'Y' then 'YES'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end as SoldasVAcantcorrect
from hussainportforlio.dbo.nasvillehousing


update nasvillehousing
set SoldAsVacant =  case
	when SoldAsVacant = 'Y' then 'YES'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end 
from hussainportforlio.dbo.nasvillehousing

select SoldAsVacant 
from hussainportforlio.dbo.nasvillehousing
group by SoldAsVacant


--removING duplicate
with rownumbcte as (
select*,
	row_number () over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order  by
				UniqueID
				) row_num
from hussainportforlio.dbo.nasvillehousing
)
delete
from rownumbcte
where row_num > 1

--checking to see if theres still any duplicate
with rownumbcte as (
select*,
	row_number () over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order  by
				UniqueID
				) row_num
from hussainportforlio.dbo.nasvillehousing
)
select*
from rownumbcte
where row_num > 1

--deleting column
alter table hussainportforlio.dbo.nasvillehousing
drop column  PropertyAddress, TaxDistrict, OwnerAddress, SaleDate


--cleaned data
select *
from hussainportforlio.dbo.nasvillehousing