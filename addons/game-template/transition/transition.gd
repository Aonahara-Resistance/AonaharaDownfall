# Transitions.
# You can tweak transition speed and appearance, just make sure to
# update `is_displayed`.
class_name Transition
extends CanvasLayer

signal progress_bar_filled
signal transition_started(anim_name)
signal transition_finished(anim_name)

onready var anim: AnimationPlayer = $AnimationPlayer
onready var progress = $ColorRect/Progress
onready var tips: Label = $ColorRect/TipsMargin/Tips
onready var texture: TextureRect = $ColorRect/TextureRect
onready var black: ColorRect = $ColorRect/Black


# Tells if transition is currently displayed
func is_displayed() -> bool:
  var is_screen_black = $ColorRect.modulate.a == 1
  return anim.is_playing() or is_screen_black


func is_transition_in_playing():
  return anim.is_playing() and anim.current_animation == "transition-in"


# appear
func fade_in(params = {}):
  randomize()
  tips.set_text("Tips: \n" + tip_list[randi() % tip_list.size()])
  progress.hide()
  if params and params.get("show_progress_bar") != null:
    if params.get("show_progress_bar") == true:
      progress.show()
  if params and params.get("show_texture") != null:
    if params.get("show_texture") == false:
      texture.set_visible(false)
      black.set_visible(true)
    else:
      texture.set_visible(true)
      black.set_visible(false)
  if params and params.get("show_tips") != null:
    if params.get("show_tips") == false:
      tips.set_visible(false)
    else:
      tips.set_visible(true)
  anim.play("transition-in")


# disappear
func fade_out():
  if progress.visible and not progress.is_completed():
    yield(self, "progress_bar_filled")
  anim.connect("animation_finished", self, "_on_fade_out_finished", [], CONNECT_ONESHOT)
  anim.play("transition-out")


func _on_fade_out_finished(cur_anim):
  if cur_anim == "transition-out":
    progress.bar.value = 0


# progress_ratio: value between 0 and 1
func _update_progress_bar(progress_ratio):
  var tween = progress.tween
  if tween.is_active():
    tween.stop_all()  # stop previous animation
  tween.interpolate_property(
    progress.bar,
    "value",
    progress.bar.value,
    progress_ratio,
    1,
    Tween.TRANS_QUAD,
    Tween.EASE_IN_OUT,
    0
  )
  tween.start()
  if progress_ratio == 1:
    yield(tween, "tween_completed")
    emit_signal("progress_bar_filled")


# called by the scene loader
func _on_resource_stage_loaded(stage: int, stages_amount: int):
  if progress.visible:
    var percentage = float(stage) / float(stages_amount)
    _update_progress_bar(percentage)
  else:
    pass


func _on_AnimationPlayer_animation_finished(anim_name):
  if anim_name == "transition-out":
    emit_signal("transition_finished", anim_name)


func _on_AnimationPlayer_animation_started(anim_name):
  if anim_name == "transition-in":
    emit_signal("transition_started", anim_name)


var tip_list = [
  "People die when they are killed",
  "Is this a loading screen?",
  "When the tips are sus",
  "Not getting hit by the enemy is a great strategy to survive",
  "i think i peed",
  "The cake is a lie",
  "Use emu, like seriously ",
  "Don't trust the fox",
  '*cue Idolm@ster "Loading" song*',
  "Pregnant Nitsuppi is canon",
  "there are no boys in Aonahara (real)",
  "what is nightcore?",
  "money can be exchanged for goods and services",
  "suipiss is 95% apple juice",
  "if everyone in the world nuts at the same time, the collective volume of the cum would be equivalent to 119 million bananas",
  "scientists have recently found that the big bang was caused by your mother",
  "Read these, it'll help, it's totally helpful and not just shitposts",
  "Switch between charachters more often since stamina and cooldown regenerates while you're not using them",
  "Someone put effort into typing these, please appreciate them!",
  "Eurobeat in the background gives you faster reaction time",
  "I'll be honest most of these are just shitposts",
  "Just don't get hit. ez right?",
  "Get a life",
  "Limit breaking the starter loom of characters unlocks their exclusive skill.",
  "If you interact with the sparkly thingies, something good will happen!",
  "Enemies have a set pattern to their attacks, it would do you good to memorize them.",
  "Some bosses are weak to debuffs. Set your party accordingly and ensure victory!",
  "Some bosses are immune to debuffs. Be careful!",
  "There are three types of monsters: normal, elite, boss.",
  "Elite monsters are bigger than normal ones and are mostly distinguishable by their red outline. Some of them also have special skills. ",
  "There's a good chance that you will find items or important information when you explore the world.",
  "Changing weapons might also change your light and heavy attacks.",
  "Blessings are buffs that can be acquired by liberating the deity shrines.",
  "Condensed Life Energy can be used to level up characters.",
  "Aonacoins is used to buy items, accessories, consumables, and weapons.",
  "Consumables can be used to buff your character before battle or replenish their health or stamina them during one.",
  "Accessories can be used to increase the stats of your character.",
  "Items can give you information or ",
  "Some weapons have unique passives.",
  "Accessories can be obtained from shops, bosses or exploration.",
  "Consumables can be obtained from shops. ",
  "Deity souls can be used to enchance your weapon.",
  "Bosses have different phases wherein their attack pattern changes.",
  "You can learn more about a character through the character page.",
]
