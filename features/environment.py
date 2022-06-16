
from steps.common import webapp
from framework.driver import Driver

def before_feature(context,feature):
    webapp.driver = Driver()

def after_feature(context,feature):
    #print("###########################################################################")
    webapp.driver.close()