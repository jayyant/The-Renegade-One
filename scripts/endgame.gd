extends Control

@onready var enemies_killed: Label = $EnemiesKilledFin
@onready var friendlies_killed: Label = $FriendliesKilledFin
@onready var choices_made: Label = $ChoicesMadeFin
@onready var game_manager: Node2D = %GameManager
@onready var ending_text: Label = $EndingText
@onready var finish: Button = $Finish


var endingDict = {
	"GoodEnding" : "You are a war hero! You slaughtered the people on the other side and made sure we won at all costs. You're the reason George lived a happy life, Martha found inner peace and the Spy was hung for his treachery. You can now retire knowing you played a good part in saving the world, although you do have a messed up moral compass now...",
	"BadEnding" : "Are you blind? You killed your own men more than you even touched the Wing Men's soldiers. Your punishment: Death Sentence. You will go down in history as the dumbest soldier to ever live.",
	"NeutralEnding" : "Well done scout! You did not kill anyone and hence there is no blood on your hands and your conscience is clean. You recieve your medal just like everyone else, and go on to live a boring, happy life with a clear conscience, only getting amazing stories to tell people along the way.",
	"SecretEnding" : "Somehow, you killed an equal number of your own men as well as the Wing Men troops. How did you even--? Nevermind that, because of your actions, you get exiled from society and go on to live in the forest with only wild animals to keep you company. Good for you if you're an introvert",
	"ChoicesEnding" : "You lied to John Melon, Left George to die, Gave away information to the Spy and Lied to Martha as well. Congratulations, spy! You've served your country well. Unfortunately, the Wing Men lost the war, so it seems you either escape or face trial now. Yikes."
}

var finalending

var EK: int
var FK: int
var choices: int

func _ready() -> void:
	finish.hide()
	
	EK = game_manager.getKillsE()
	FK = game_manager.getKillsF()
	choices = game_manager.getChoices()

	checkAll()
	enemies_killed.text = "You killed %d enemies." % EK
	friendlies_killed.text = "You killed %d friendlies." % FK
	choices_made.text = "You made %d bad choices." % choices
	
	await get_tree().create_timer(2).timeout
	ending_text.text = endingDict.get(finalending, "No ending found.")
	
	await get_tree().create_timer(10).timeout
	finish.show()




func checkAll():
	if choices >= 3:
		finalending = "ChoicesEnding"
	else:
		if EK > FK:
			finalending = "GoodEnding"
		elif FK > EK:
			finalending = "BadEnding"
		elif FK == EK and FK!=0 and EK!= 0:
			finalending = "SecretEnding"
		else:
			finalending = "NeutralEnding"


func _on_finish_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
