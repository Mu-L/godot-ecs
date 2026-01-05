extends RefCounted
class_name DataPacker

# ==============================================================================
# public
signal on_packed(sender: DataPacker, pack: DataPack)
signal on_unpacked(sender: DataPacker, pack: DataPack)

# ==============================================================================
# public
func pack() -> DataPack:
	var dp := _pack()
	on_packed.emit(self, dp)
	return dp
	
func unpack(dp: DataPack) -> bool:
	if _unpack(dp):
		on_unpacked.emit(self, dp)
		return true
	return false
	
# ==============================================================================
# override
func _pack() -> DataPack:
	return null
	
# override
func _unpack(data: DataPack) -> bool:
	return false
	
