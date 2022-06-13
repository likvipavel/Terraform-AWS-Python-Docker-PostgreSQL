from user import User
from database import Database
import os


Database.initialise(database="postgres",
                    user="postgres", password=os.environ.get('PG_PASS'),
                    host=os.environ.get('PG_HOST'))

user = User('jose@schoolofcode.me', 'Jose', 'Salvatierra')

user.save_to_db()

user_from_db = User.load_from_db_by_email('jose@schoolofcode.me')

print(user_from_db)
