import random

def assign_infection_level():
    number = int(random.uniform(0, 4))
    levels = ["asymptomatic", "mild", "moderate", "serious"]
    return levels[number]

def genter_probability():
    # Source https://www.eltiempo.com/bogota/numero-de-habitantes-de-bogota-segun-el-censo-del-dane-384540
    male = 3433604
    female = 3747944
    total = male + female
    female_percentage = female / total
    number = random.random()
    if number <= female_percentage:
        return "female"
    return "male"

"""
assign_place_of_care
Parameters: 
    * infection_level: Infection level assing to the agent
Returns:
    * home: When the infection_level is mild
    * hospital: When the infection_level is moderate
    * ICU: When the infection_level is serious the person is send to ICU
"""
def assign_place_of_care(infection_level):
    if infection_level == "mild":
        return "home"
    elif infection_level == "moderate":
        return "hospital"
    elif infection_level == "serious":
        return "ICU" # UCI in spanish
    else:
        return "none"
