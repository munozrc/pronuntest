class Config:
    DEBUG = False
    SERVER_NAME = "0.0.0.0:4000"


class DevelopmentConfig(Config):
    DEBUG = True
    SERVER_NAME = "192.168.0.12:4000"


config = {"development": DevelopmentConfig, "production": Config}
