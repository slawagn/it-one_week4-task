psql -d postgres -U postgres -f ./00-create-tables.sql
psql -d postgres -U postgres -f ./10-create-procedures.sql
psql -d postgres -U postgres -f ./20-demo.sql
