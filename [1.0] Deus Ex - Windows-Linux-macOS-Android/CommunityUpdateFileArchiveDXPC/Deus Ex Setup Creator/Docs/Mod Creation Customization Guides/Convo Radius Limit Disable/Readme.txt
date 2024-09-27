This is edited to remove the convo radius check from *mid* converstaion. You still have to be in radius to start one, but you can talk to npcs from any distance now while in that convo. 
I did originally disable the check universally, and believe me, that's a mess. All convos try to start at once, because of course they do.
Made it so I could make a convo based on Tom Cardy's "Perception Check", could be used for all kinds of convo shenanigans. 

If you wanted to for some reason start a convo with another character across a map, say for a third person perspective phone call / infolink convo, you could always make an invisible / intangible NPC as a convo starter. Using a conversationtrigger if needed?


Additional notes:

Sometimes you also need to have a camera angle change before a jump? If you add conversation before the jump without also adding a camera angle before the jump, the camera stays on the pre-jump convo owner.
Not sure on the exact conditions that make this required?

Talking to hidden npcs works but can be finicky? Specifically with it not wanting to change camera positions when talking to one. Might be able to workaround by instead of setting hidden, giving an npc invisible textures?