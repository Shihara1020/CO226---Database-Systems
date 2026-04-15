import sqlparse

sql = "select * from users where id=1;"
formatted_sql = sqlparse.format(sql, reindent=True, keyword_case='upper')
print(formatted_sql)
