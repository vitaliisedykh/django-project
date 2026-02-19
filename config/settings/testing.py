from .base import *

DEBUG = True
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'sitewoman_test',
        'USER': 'postgres',
        'PASSWORD': 'postgres',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}
STATIC_URL = '/static/'
ALLOWED_HOSTS = ['localhost', '127.0.0.1']
SECRET_KEY = 'test-secret-key-for-testing-only'