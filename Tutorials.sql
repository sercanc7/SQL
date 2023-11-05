--1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.

SELECT Product_Name, Quantity_Per_Unit FROM products;

--2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.

SELECT product_id, Product_Name FROM products WHERE discontinued = 0;

--3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.

SELECT product_id, Product_Name FROM products;

--4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.

SELECT product_id, Product_Name, Unit_Price FROM products WHERE unit_price < 20;

--5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın

SELECT product_id, Product_Name, Unit_Price FROM products WHERE unit_price BETWEEN 15 AND 25;

--6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.

SELECT product_name, Units_on_Order, Units_in_Stock FROM products WHERE Units_in_Stock < Units_on_Order;

--7. İsmi `a` ile başlayan ürünleri listeleyeniz.

SELECT * FROM products WHERE LOWER(product_name) LIKE 'a%';

--8. İsmi `i` ile biten ürünleri listeleyeniz.

SELECT * FROM products WHERE LOWER(product_name) LIKE '%i';

--9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.

SELECT product_name,Unit_Price,((Unit_Price*0.18) + Unit_Price) AS "UnitPriceKDV" FROM products;

--10. Fiyatı 30 dan büyük kaç ürün var?

SELECT Count(*) FROM products WHERE unit_price > 30;

--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele

SELECT LOWER(product_name),unit_price FROM products ORDER BY unit_price DESC;

--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır

SELECT CONCAT(first_name,' ',last_name) AS "Adı Soyadı" FROM employees;

--13. Region alanı NULL olan kaç tedarikçim var?

SELECT COUNT(*) FROM suppliers WHERE region IS NULL;

--14. a.Null olmayanlar?

SELECT COUNT(*) FROM suppliers WHERE region IS NOT NULL;

--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.

SELECT CONCAT('TR ',UPPER(product_name)) FROM products;

--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle

SELECT CONCAT('TR ',UPPER(product_name)) FROM products WHERE unit_price < 20;

--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

SELECT product_name, Unit_price FROM products WHERE unit_price = (SELECT MAX(unit_price) FROM products);

--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

SELECT product_name, Unit_price FROM products ORDER BY Unit_price DESC LIMIT 10;

--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

SELECT product_name, Unit_price FROM products WHERE Unit_price > (SELECT AVG(Unit_price) FROM products);

--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.

select sum(unit_price * units_in_stock) as toplam_kar from products; 

--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.

select *from products inner join categories on categories.category_id = products.category_id ;

--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.

SELECT categories.category_name, round(avg(products.unit_price)) AS urun_ortalaması FROM products
INNER JOIN categories ON products.category_id = categories.category_id
GROUP BY categories.category_name;

--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?

select product_name,unit_price,category_name from products
inner join categories on products.category_id = categories.category_id
where unit_price = (select max(unit_price) from products);

--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı ?

SELECT p.product_name, categories.category_name, suppliers.contact_name
FROM products p
JOIN categories ON categories.category_id = p.category_id
JOIN suppliers ON p.supplier_id = suppliers.supplier_id
WHERE p.product_id = (
    SELECT product_id
    FROM order_details
    GROUP BY product_id
    ORDER BY COUNT(quantity) DESC
    LIMIT 1
);

--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
Select p.product_id, p.product_name, s.company_name, s.phone, p.units_in_stock   From products p
Inner Join suppliers s ON p.supplier_id = s.supplier_id
Where p.units_in_stock =0

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
Select o.order_id, o.order_date, o.employee_id, o.ship_address, e.first_name, e.last_name From orders o
Inner Join employees e ON  o.employee_id = e.employee_id
Where date_part('year',o.order_date) = 1998 AND date_part('month',o.order_date) = 03

--28. 1997 yılı şubat ayında kaç siparişim var?
Select COUNT(o.order_id) From orders o
Where date_part('year',o.order_date) = 1997 AND date_part('month',o.order_date) = 02

--29. London şehrinden 1998 yılında kaç siparişim var?
Select COUNT(o.order_id) From orders o
Where date_part('year',o.order_date) = 1998 AND o.ship_city = 'London'

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
Select o.customer_id, c.contact_name, c.phone  From orders o
Inner Join customers c ON c.customer_id = o.customer_id
Where date_part('year',o.order_date) = 1997
Group By o.customer_id,c.contact_name, c.phone

--31. Taşıma ücreti 40 üzeri olan siparişlerim
Select * From orders o 
Where o.freight >40

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
Select o.ship_city,  c.company_name,o.freight From orders o 
Inner Join customers c ON o.customer_id = c.customer_id 
Where o.freight >40

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
Select o.ship_city, o.order_date, UPPER(CONCAT(e.first_name, ' ', e.last_name))  From orders o
Inner Join employees e ON e.employee_id = o.employee_id
Where date_part('year',o.order_date) = 1997

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
Select o.customer_id, c.contact_name,regexp_replace(c.phone, '[^0-9]', '', 'g')  AS TELEFON  From orders o
Inner Join customers c ON c.customer_id = o.customer_id
Where date_part('year',o.order_date) = 1997 
Group By o.customer_id, c.contact_name, c.phone

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyadı
Select o.order_date, c.contact_name, e.first_name,e.last_name From orders o
Inner Join employees e ON e.employee_id = o.employee_id
Inner Join customers c ON c.customer_id = o.customer_id

--36. Geciken siparişlerim?
Select * From orders 
Where required_date < shipped_date

--37. Geciken siparişlerimin tarihi, müşterisinin adı
Select o.order_date, c.company_name,o.required_date,o.shipped_date From orders o
Inner Join customers c ON c.customer_id = o.customer_id
Where o.required_date < o.shipped_date

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
Select p.product_name, c.category_name, od.quantity From order_details od
Inner Join products p ON p.product_id = od.product_id
Inner Join categories c ON c.category_id = p.category_id
Where od.order_id = 10248

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
Select p.product_name,s.company_name, od.quantity From order_details od
Inner Join products p ON p.product_id = od.product_id
Inner Join suppliers s ON s.supplier_id = p.supplier_id
Where od.order_id = 10248

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT products.product_name, SUM(order_details.quantity) FROM order_details
INNER JOIN products ON products.product_id = order_details.product_id
INNER JOIN orders ON orders.order_id = order_details.order_id
WHERE orders.employee_id = 3 AND date_part('year', orders.order_date) = 1997 
GROUP BY order_details.product_id,products.product_name

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, e.first_name || ' ' || e.last_name as ad_soyad from employees e where e.employee_id = (select o.employee_id from orders o join order_details od on o.order_id = od.order_id
 where EXTRACT(YEAR FROM o.order_date) = 1997
group by o.order_id order by sum(od.quantity * od.unit_price ) desc limit 1)

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name, e.last_name, e.title, e.hire_date,
       SUM(od.quantity * od.unit_price) AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
WHERE date_part('year', o.order_date) = 1997
GROUP BY e.employee_id, e.first_name, e.last_name, e.title, e.hire_date
ORDER BY total_sales DESC
LIMIT 1;

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, c.category_name, p.unit_price from products p
join categories c on p.category_id = c.category_id
order by unit_price desc limit 1 

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name, e.last_name, o.order_date, o.order_id
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
ORDER BY o.order_date;

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_id, AVG(od.unit_price * od.quantity) AS average_price
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, sum(od.quantity) FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON p.product_id = od.product_id
INNER JOIN categories c ON c.category_id = p.category_id
WHERE date_part('month',o.order_date) = 01
GROUP BY p.product_name,c.category_name

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT order_id,(quantity*unit_price) AS miktar FROM order_details
WHERE (quantity*unit_price) > (SELECT AVG(quantity * unit_price) FROM order_details)
GROUP BY order_id, product_id

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name, s.contact_name from products p join categories c on c.category_id = p.category_id
join suppliers s on s.supplier_id = p.supplier_id 
where p.product_id = (select od.product_id as sales_count from order_details od
group by od.product_id order by sales_count desc limit 1)

--49. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT country) AS customer_count
FROM customers;

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT o.employee_id,round(SUM(od.unit_price * od.quantity)) FROM orders o
INNER JOIN order_details od ON o.order_id = od.order_id
WHERE o.employee_id = 3 AND o.order_date >= '1998-01-01'
GROUP BY o.employee_id

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
Select p.product_name, c.category_name, od.quantity From order_details od
Inner Join products p ON p.product_id = od.product_id
Inner Join categories c ON c.category_id = p.category_id
Where od.order_id = 10248

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
Select p.product_name,s.company_name, od.quantity From order_details od
Inner Join products p ON p.product_id = od.product_id
Inner Join suppliers s ON s.supplier_id = p.supplier_id
Where od.order_id = 10248

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT products.product_name, SUM(order_details.quantity) FROM order_details
INNER JOIN products ON products.product_id = order_details.product_id
INNER JOIN orders ON orders.order_id = order_details.order_id
WHERE orders.employee_id = 3 AND date_part('year', orders.order_date) = 1997 
GROUP BY order_details.product_id,products.product_name

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, e.first_name || ' ' || e.last_name as ad_soyad from employees e where e.employee_id = (select o.employee_id from orders o join order_details od on o.order_id = od.order_id
 where EXTRACT(YEAR FROM o.order_date) = 1997
group by o.order_id order by sum(od.quantity * od.unit_price ) desc limit 1)

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name, e.last_name, e.title, e.hire_date,
       SUM(od.quantity * od.unit_price) AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
WHERE date_part('year', o.order_date) = 1997
GROUP BY e.employee_id, e.first_name, e.last_name, e.title, e.hire_date
ORDER BY total_sales DESC
LIMIT 1;

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name from products p
inner join categories c on p.category_id = c.category_id
order by p.unit_price desc
limit 1

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name, e.last_name, o.order_date, o.order_id
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
ORDER BY o.order_date;

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_id, AVG(od.unit_price * od.quantity) AS average_price
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, sum(od.quantity) FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON p.product_id = od.product_id
INNER JOIN categories c ON c.category_id = p.category_id
WHERE date_part('month',o.order_date) = 01
GROUP BY p.product_name,c.category_name

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT order_id,(quantity*unit_price) AS miktar FROM order_details
WHERE (quantity*unit_price) > (SELECT AVG(quantity * unit_price) FROM order_details)
GROUP BY order_id, product_id

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name, s.contact_name from products p join categories c on c.category_id = p.category_id
join suppliers s on s.supplier_id = p.supplier_id 
where p.product_id = (select od.product_id as sales_count from order_details od
group by od.product_id order by sales_count desc limit 1)

--62. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT country) AS customer_count
FROM customers;

--63. Hangi ülkeden kaç müşterimiz var
SELECT country, COUNT(*) AS "Müşteri Sayısı" FROM customers
GROUP BY country

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select o.employee_id, round(SUM(od.unit_price*od.quantity)) from order o
inner join order_details od on o.order_id=od.order_id
where o.employee_id=3 and o.order_date>= '1998-01-01'
group by o.employee_id

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
Select SUM(od.unit_price * od.quantity) from order_details od
inner join orders o ON o.order_id = od.order_id
Where od.product_id = 10 AND o.order_date >= (SELECT order_date FROM orders ORDER BY order_date DESC LIMIT 1) - INTERVAL '3 months'

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.employee_id, e.first_name, e.last_name, count(o.order_id) from orders o
join employees e on e.employee_id = o.employee_id
group by o.employee_id, e.employee_id
order by count(o.order_id) desc

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.customer_id, c.company_name from orders o
right join customers c on c.customer_id = o.customer_id 
where order_id is null 

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name, contact_name, address, city, region, postal_code from customers
where country IN ('Brazil')

--69. Brezilya’da olmayan müşteriler
select * from customers 
where country not IN ('Brazil')

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers 
where country IN ('Germany', 'Spain', 'France')

--71. Faks numarasını bilmediğim müşteriler
select * from customers
where fax is null

--72. Londra’da ya da Paris’de bulunan müşterilerim
select * from customers
where city IN('London','Paris')

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select * from customers
where city IN('México D.F.') AND contact_title='Owner'

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name, unit_price from products
where product_name LIKE'C%'

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name, last_name, birth_date from employees
where first_name LIKE'A%'

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select company_name from customers
where company_name LIKE'%RESTAURANT%'

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name, unit_price from products
where unit_price between 50 and 100;

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id, order_date
FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31';

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers 
where country IN ('Germany', 'Spain', 'France')

--80. Faks numarasını bilmediğim müşteriler
select * from customers
where fax is null

--81. Müşterilerimi ülkeye göre sıralıyorum:
select * from customers
order by country 

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price from products
order by unit_price desc

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price
from products
order by unit_price DESC, units_in_stock;

--84. 1 Numaralı kategoride kaç ürün vardır..?
select count(*) from products p
inner join categories c on c.category_id=p.category_id
where c.category_id=1

--85. Kaç farklı ülkeye ihracat yapıyorum..?
SELECT COUNT(DISTINCT country) AS country_count
FROM customers;
