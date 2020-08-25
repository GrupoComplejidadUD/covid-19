import random
"""
illness_evolution evaluate the evolution of infection through the time
source: http://saludata.saludcapital.gov.co/osb/index.php/datos-de-salud/enfermedades-trasmisibles/covid19/ 
for 20-june-2020
"""
def illness_evolution(infection_level, time_infection):
    if ((time_infection % 24) == 0):
        if infection_level == "asymptomatic":
            x = random.random()
            probability = time_infection * 0.00290178571428571
            if (x <= probability):
                return "mild"
            else:
                return "asymptomatic"
        elif infection_level == "mild":
            x = random.random()
            probability = time_infection * 0.000148229
            if ((probability <= 0.05) and (x <= probability)):
                return "severe"
            else:
                return "mild"
        elif infection_level == "severe":
            x = random.random()
            probability = time_infection * 7.89933E-06
            if ((probability <= 0.008) and (x <= probability)):
                return "critical"
            else:
                return "severe"
        elif infection_level == "critical":
            return "critical"
        else:
            return "asymptomatic"
    else:
        return infection_level

"""
healing_evolution
The idea with this function is multiply the probability to heal per hour and
compare with a random number, if it's less or equal the person update his
status to recoved, else continue like infected.
"""
def healing_evolution(time_infection):
    x = random.random()
    probability = time_infection * 0.000313844
    if x <= probability:
        return "recovered"
    else:
        return "infected"

def die_evolucion(time_infection):
    x = random.random()
    probability = time_infection * 1.73863E-05
    if x <= probability:
        return "die"
    else:
        return "alive"

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
    * hospital: When the infection_level is severe
    * ICU: When the infection_level is critical the person is send to ICU
"""
def assign_place_of_care(infection_level):
    if infection_level == "mild":
        return "home"
    elif infection_level == "severe":
        return "hospital"
    elif infection_level == "critical":
        return "ICU" # UCI in spanish
    else:
        return "none"

"""
assing the age
information taken from http://saludata.saludcapital.gov.co/osb/index.php/datos-de-salud/demografia/piramidepoblacional/
"""
def age_probability():
    # return int(random.normalvariate(38.65425, 18.6908))
    number = random.random()
    if (number <= 0.07):
        return random.randint(0,4)
    elif (number <= 0.15):
        return random.randint(5,9)
    elif (number <= 0.22):
        return random.randint(10,14)
    elif (number <= 0.3):
        return random.randint(15,19)
    elif (number <= 0.38):
        return random.randint(20,24)
    elif (number <= 0.46):
        return random.randint(25,29)
    elif (number <= 0.53):
        return random.randint(30,34)
    elif (number <= 0.61):
        return random.randint(35,39)
    elif (number <= 0.69):
        return random.randint(40,44)
    elif (number <= 0.75):
        return random.randint(45,49)
    elif (number <= 0.81):
        return random.randint(50,54)
    elif (number <= 0.87):
        return random.randint(55,59)
    elif (number <= 0.91):
        return random.randint(60,64)
    elif (number <= 0.95):
        return random.randint(65,69)
    elif (number <= 0.97):
        return random.randint(70,74)
    elif (number <= 0.99):
        return random.randint(75,79)
    elif (number <= 1):
        return random.randint(80,100)

"""
min_time_infection
It returns the minimum time o infection in hours
"""
def min_time_infection(infection_level):
    if infection_level == "mild":
        return weeks_to_hours(2)
    elif infection_level == "severe":
        return weeks_to_hours(3)
    elif infection_level == "critical":
        return weeks_to_hours(6)
    else:
        return weeks_to_hours(2)

def max_time_infection(infection_level):
    if infection_level == "mild":
        return weeks_to_hours(2)
    elif infection_level == "severe":
        return weeks_to_hours(6)
    elif infection_level == "critical":
        return weeks_to_hours(8)
    else:
        return weeks_to_hours(2)

def weeks_to_hours(weeks):
    days = weeks_to_days(weeks)
    return days_to_hours(days)

def days_to_hours(days):
    return days*24

def weeks_to_days(weeks):
    return weeks*7

def probability_to_symptoms(time_infection):
    probability = random.random()
