import random

"""
assign_infection_level

This function assing the infection level with the next rules:
    * 80% of all population would sick
        * 80% of sick people are asymptomatic
        * 20% of sick are symtomatic
            * 98% of symtomatic are "mild" and are in home
            * 2% of symtomatic are in a hospital
                * 80% are "moderate"
                * 20% are "serious"
"""
def assign_infection_level():
    number = random.random()
    # levels = ["asymptomatic", "mild", "moderate", "serious"]
    if (number <= 0.004):
        x = random.random()
        if (x <= 0.8):
            return "moderate"
        else:
            return "serious"
    elif (number <= 0.196):
        return "mild"
    else:
        return "asymptomatic"

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

