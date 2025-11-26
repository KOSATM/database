SELECT 
    'ALTER TABLE ' || tc.table_name || 
    ' DROP CONSTRAINT ' || tc.constraint_name || ';'
FROM 
    information_schema.table_constraints tc
WHERE 
    tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
ORDER BY 
    tc.table_name;