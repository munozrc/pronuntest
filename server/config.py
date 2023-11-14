class Config:
    DEBUG = False


class DevelopmentConfig(Config):
    DEBUG = True
    SERVER_NAME = "192.168.0.12:4000"


config = {"development": DevelopmentConfig, "production": Config}
