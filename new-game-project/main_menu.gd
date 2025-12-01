extends Control

var ip

func _on_exit_button_down() -> void:
	get_tree().quit()


func _on_connect_button_down() -> void:
	pass # Replace with function body.

func _on_i_pentry_lines_edited_from(from_line: int, to_line: int) -> void:
	var new_ip = $IPentry.text
	ip = new_ip
	print(ip)
