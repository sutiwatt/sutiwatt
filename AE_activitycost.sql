SELECT  to_char(orders.created_at,'YYYY-MM') as create_month,
        marketplaces.type as marketplace_name,
        COUNT(distinct orders.id) as total_orders
FROM orders
LEFT JOIN shops on shops.id = orders.shop_id
LEFT JOIN outbound_informations ON outbound_informations.order_id = orders.id
LEFT JOIN marketplaces ON orders.marketplace_id = marketplaces.id
LEFT JOIN order_line_items ON order_line_items.order_id = orders.id
LEFT JOIN inventory_items ON order_line_items.inventory_item_id = inventory_items.id
LEFT JOIN product_variants ON inventory_items.product_variant_id = product_variants.id
LEFT JOIN products ON product_variants.product_id = products.id
LEFT JOIN product_categories ON products.product_category_id = product_categories.id
WHERE order_type = 'outbound' AND orders.state in ('shipped','delivered','awaiting_strategy','on_hold','packing','picking','printed','ready_to_pack','ready_to_pick','ready_to_ship','shipping')
                              AND {{shop_name}} 
                              AND {{set_date}}
                              AND {{sub_shop_name}}
                              AND orders.deleted_at is null
                              AND outbound_informations.deleted_at is Null
                              AND {{shop_contains}}
GROUP BY marketplace_name, create_month
ORDER BY total_orders DESC, create_month DESC