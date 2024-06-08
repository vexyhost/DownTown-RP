function BagsLoad ()
	local smalltxd = engineLoadTXD("Mochilas/small.txd", true)
	engineImportTXD(smalltxd, 2081)
	local smalldff = engineLoadDFF("Mochilas/small.dff", 2081)
	engineReplaceModel(smalldff, 2081)
	
	local alicetxd = engineLoadTXD("Mochilas/alice.txd", true)
	engineImportTXD(alicetxd, 2082)
	local alicedff = engineLoadDFF("Mochilas/alice.dff", 2082)
	engineReplaceModel(alicedff, 2082)
	
	local czechtxd = engineLoadTXD("Mochilas/czech.txd", true)
	engineImportTXD(czechtxd, 2083)
	local czechdff = engineLoadDFF("Mochilas/czech.dff", 2083)
	engineReplaceModel(czechdff, 2083)
	
	local coyotetxd = engineLoadTXD("Mochilas/coyote.txd", true)
	engineImportTXD(coyotetxd, 2084)
	local coyotedff = engineLoadDFF("Mochilas/coyote.dff", 2084)
	engineReplaceModel(coyotedff, 2084)

end
addEventHandler("onClientResourceStart", resourceRoot, BagsLoad)      