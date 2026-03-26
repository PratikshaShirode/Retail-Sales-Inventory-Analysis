create database Project;
use Project;
select * from goods_receipt;
select * from inventory_snapshot;
select * from product_supplier_mapping;
select * from products_master;
select * from promotions;
select * from purchase_orders;
select * from realistic_retail_sales_10k;
select * from sales_fact;
select * from stores_master;
select * from suppliers_master;
#1.Find total quantity sold and total revenue for each product. 
SELECT 
    product_id,
    SUM(quantity_sold) quantity_sold,
    SUM(net_revenue) total_revenue
FROM
    sales_fact
GROUP BY product_id;

#2.Show total sales amount for each sales date.
SELECT 
    order_date, SUM(quantity_sold) total_sales
FROM
    sales_fact
GROUP BY order_date;

#3.Identify the top 10 products based on total quantity sold.
SELECT 
    product_id, SUM(quantity_sold) quantity_sold
FROM
    sales_fact
GROUP BY product_id
ORDER BY quantity_sold DESC
LIMIT 10;

#4.Calculate total sales for each store.
SELECT 
    store_id, COUNT(quantity_sold) total_sales
FROM
    sales_fact
GROUP BY store_id;

#5.Find products that never had any sales.
SELECT 
    p.product_id, p.product_name
FROM
    products_master p
        LEFT JOIN
    sales_fact s ON p.product_id = s.product_id
WHERE
    s.product_id IS NULL;
    
    #6.Calculate monthly total sales and revenue.
    SELECT 
    DATE_FORMAT(order_date, '%y-%m') sales_month,
    SUM(quantity_sold)mothly_total_sale,
    SUM(unit_price) total_revenue
    from sales_fact 
    group by DATE_FORMAT(order_date,'%y-%m')
    order by sales_month;
    
    #7.Identify products that had zero inventory on any day
    select distinct p.product_id,p.product_name 
    from Inventory_snapshot i join products_master p on i.product_id=p.product_id
    where i.stockout_flag=0 order by product_id ;
    
    select * from goods_receipt;
    #8.find total received quantity
    SELECT 
    COUNT(received_quantity) Total_Received_Quantity
FROM
    goods_receipt;
    
    #9.find received quantity on this 2022-01-15 date
    SELECT 
    received_quantity
FROM
    goods_receipt
WHERE
    actual_delivery_date = '2022-01-15';
    
#10.po_id 2 order_date order_quantity received
SELECT 
    p.po_id, p.order_date, p.order_quantity, g.received_quantity
FROM
    purchase_orders p
        JOIN
    goods_receipt g ON p.po_id = g.po_id
WHERE
    p.po_id = 2;
    
    select * from products_master;
    #11.find the product name that cost_prize is grater than 50k
    SELECT 
    product_name,category
FROM
    products_master
WHERE
    cost_price > 50000;
    
    #12.find product count of category wise
    SELECT 
    category, COUNT(category)Total_product_count
FROM
    products_master
GROUP BY category;

#13.find product name whose base_price between 40k-50k
select product_name,category from products_master where base_price between 40000 and 50000;

#14.find product name,base price,cost price of electronic category 
select product_name,base_price,cost_price from products_master where category="Electronics";

#15.second highest cost price
SELECT 
    MAX(cost_price)
FROM
    products_master
WHERE
    cost_price < (SELECT 
            MAX(cost_price)
        FROM
            products_master);

#16.find product name and base price
select product_name,base_price,category,row_number() over (order by base_price desc)from products_master;


#17.po_id 2 order_date order_quantity received
SELECT 
    p.po_id, p.order_date, p.order_quantity, g.received_quantity
FROM
    purchase_orders p
        JOIN
    goods_receipt g ON p.po_id = g.po_id
WHERE
    p.po_id = 2;

#18.find the count of promotion type
select  count(promo_type)count_of_promo_type from promotions;

#19.find base price,cost price and promo type where category is electronics 
SELECT 
    category, p.base_price, p.cost_price, promo_type
FROM
    products_master p
        JOIN
    promotions pr ON p.product_id = pr.product_id
WHERE
    category = 'Electronics';

#20.find total base price of each category
SELECT 
    category, COUNT(base_price), SUM(base_price)
FROM
    products_master
GROUP BY category;

#21.Sales by Store
SELECT 
    st.store_id, SUM(net_revenue) AS total_revenue
FROM
    stores_master st
        JOIN
    sales_fact s ON st.store_id = s.store_id
GROUP BY store_id;

#22.Display product name category and their net revenue
SELECT 
    p.category, sum(s.net_revenue)
FROM
    products_master p
        JOIN
    sales_fact s ON p.product_id = s.product_id
GROUP BY p.category;

#23.total revenue per store
SELECT 
    store_id, SUM(net_revenue)Store_Total_Revenue
FROM
    sales_fact
GROUP BY store_id;

#24.#show top 5 highest revenue orders
SELECT 
    *
FROM
    sales_fact
ORDER BY net_revenue DESC
LIMIT 5;

#25.sort orders by order date leatest first
SELECT 
    order_id, order_date
FROM
    sales_fact
ORDER BY order_date DESC;

#25.show records where discount is applied
SELECT 
    *
FROM
    sales_fact
WHERE
    discount_pct >= 0;
    
#26.find stores with the revenue greater than 50k
SELECT 
    store_id, net_revenue
FROM
    sales_fact
WHERE
    net_revenue > 50000;
#27.find the each store total revenue greater than 50k
SELECT 
    store_id, SUM(net_revenue)
FROM
    sales_fact
GROUP BY store_id
HAVING SUM(net_revenue) > 50000;

#28.Rank orders by revenue (highest first)
select order_id,net_revenue,rank() over(order by net_revenue desc)revenue_rank from sales_fact ;
 
 
 #29.Previous order revenue
 select order_id,lag(net_revenue) over(order by order_id)Previous_revenue from sales_fact;

#30.find suppliers with lead time greater than 10 days
SELECT 
    supplier_id, supplier_name, lead_time_days
FROM
    suppliers_master
WHERE
    lead_time_days > 10;
    
#31.Show suppliers from Electronics category
SELECT 
    supplier_id, supplier_name, category
FROM
    suppliers_master
WHERE
    category = 'Electronics';
    
#32.List suppliers ordered by lead time (fastest first)
SELECT 
    supplier_id, lead_time_days
FROM
    suppliers_master
ORDER BY lead_time_days ASC;

#33.show categories with more than 1 supplier
SELECT 
    p.category,
    COUNT(DISTINCT ps.supplier_id) AS supplier_count
FROM products_master p
JOIN product_supplier_mapping ps
    ON p.product_id = ps.product_id
JOIN suppliers_master s
    ON ps.supplier_id = s.supplier_id
GROUP BY p.category
HAVING COUNT(DISTINCT ps.supplier_id) > 1;

#34.List suppliers ordered by lead time (fastest first)
select supplier_id,lead_time_days from suppliers_master order by lead_time_days asc;

#35.show categories with more than 1 supplier
select category from  suppliers_master group by category having count(distinct supplier_id)>1;

#36.Which products drive most revenue?
SELECT 
    p.product_name,
    SUM(s.net_revenue) AS total_revenue
FROM sales_fact s
JOIN products_master p
    ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

#37.Which products frequently go out of stock?
SELECT 
    p.product_name, COUNT(*) AS stockout_days
FROM
    products_master p
        JOIN
    inventory_snapshot i ON p.product_id = i.product_id
WHERE
    i.stockout_flag = 0
GROUP BY p.product_name
ORDER BY stockout_days asc;

# Which stores generate high sales
SELECT 
    sm.store_id, SUM(sf.net_revenue) AS total_revenue
FROM
    sales_fact sf
        JOIN
    stores_master sm ON sf.store_id = sm.store_id
GROUP BY sm.store_id
ORDER BY total_revenue DESC
LIMIT 5;