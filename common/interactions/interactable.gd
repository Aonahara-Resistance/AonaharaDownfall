extends Node2D
class_name Interactable

# damn how
# so let's say
# character interaction area enters interactable
# what happen then?
# should it interaction detect interactable or otherwise? 
# i think i got it
# interactable enters interaction
# add to interactions array in character
# if it's the only item in list call the show_ui thingy
# in interaction there should be a method to traverse the interactions list
# as well as calling interact when the correct button and conditions are met
# now what do i do after the item has been interacted?
# some item might get destroyed, some might not
# i need a way to send what to do after the interact is called?
# maybe i should pass the host to interact
# then maybe the something like host delete_interaction(self)
# which will queue free the interactable and delete it from the array in interactions
# if the interactable needs to be freed
# what if it's a pick up item :thonk:
# completely detached from character interaction and interactable
# with something like healt pickup i can do like interactions.character
# maybe on the interact iself i'll call a signal based on what it does 
# maybe emit_signal(item_picked_up, thing)
# which will be listened by the inventory thing
# yeah that'll work

func show_ui():
  pass

func interact():
  pass

func _on_Area2D_area_entered(_area: Area2D):
  pass

