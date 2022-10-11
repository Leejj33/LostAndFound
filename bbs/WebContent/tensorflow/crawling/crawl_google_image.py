from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time
import urllib.request
import os

pumjong = {
     "분실물": ["백팩", "반지"]
}


def crawling(target_name):
    driver.get("https://www.google.co.kr/imghp?hl=ko&ogbl")
    elem = driver.find_element_by_name("q")
    elem.send_keys(target_name)
    elem.send_keys(Keys.RETURN)
    # (Seconds) Increase this number if your network is slow
    SCROLL_PAUSE_TIME = 3
    NUMBER_OF_PICTURES = 50  # Increase this number if you want to get more pictures
    # Get scroll height
    last_height = driver.execute_script("return document.body.scrollHeight")

    count = 0
    while count < NUMBER_OF_PICTURES:
        # while True:
        # Scroll down to bottom
        driver.execute_script(
            "window.scrollTo(0, document.body.scrollHeight);")

        # Wait to load page
        time.sleep(SCROLL_PAUSE_TIME)

        # Calculate new scroll height and compare with last scroll height
        new_height = driver.execute_script("return document.body.scrollHeight")
        if new_height == last_height:
            try:
                driver.find_element_by_css_selector(".mye4qd").click()
            except:
                break
        last_height = new_height

        images = driver.find_elements_by_css_selector(".rg_i.Q4LuWd")

        for image in images:
            try:
                image.click()
                time.sleep(2)
                imgUrl = driver.find_element_by_xpath(
                    '/html/body/div[2]/c-wiz/div[3]/div[2]/div[3]/div/div/div[3]/div[2]/c-wiz/div/div[1]/div[1]/div[2]/div/a/img').get_attribute("src")
                urllib.request.urlretrieve(imgUrl, str(count) + ".jpg")
                count = count+1
                if count >= (NUMBER_OF_PICTURES+1):
                    break
            except:
                pass


driver = webdriver.Chrome()
for key in pumjong:
    os.makedirs(key, exist_ok=True)
    os.chdir(key)
    for val in pumjong[key]:
        os.makedirs(val, exist_ok=True)
        os.chdir(val)
        crawling(val)
        os.chdir('..')
    os.chdir('..')
driver.close()
