function onCreatePost()
{
	for (note in game.unspawnNotes)
	{
		if (note.isSustainNote)
			note.noAnimation = true;
	}
}

function goodNoteHit(note)
{
	if (note.isSustainNote)
	{
		if (note.gfNote)
			game.gf.holdTimer = 0;
		else
			game.boyfriend.holdTimer = 0;
	}
}

function opponentNoteHit(note)
{
	if (note.isSustainNote)
	{
		if (note.gfNote)
			game.gf.holdTimer = 0;
		else
			game.dad.holdTimer = 0;
	}
}