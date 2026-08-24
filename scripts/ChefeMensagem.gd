extends Control

# ============================================================
#  MENSAGEM CHEFE  -  notificação estilo Slack do founder
#
#  Aparece 2-3x durante a partida, no canto superior direito,
#  com uma fala aleatória do banco (ver HISTORIA.md > "Banco de
#  falas dele"). Puramente visual: não interfere no gameplay,
#  não lê nem escreve estado de nenhum minigame.
# ============================================================

const FALAS := [
	"Bora matar um leão por dia! 🦁",
	"Te mandei o documento do produto novo. São só 250 páginas, tá tudo lá 📄",
	"Semana que vem tem evento pra vender o produto. Precisa de umas funcionalidades extra pra demo — é fácil, coisa de dois dias 😅",
	"Pensa no equity! 💎",
	"Logo libero mais um dia de home office (só falta uma coisinha) 🏠",
]

@export var duracao_partida: float = 60.0
@export var qtd_mensagens: int = 3
@export var tempo_visivel: float = 4.0   # segundos que a notificação fica na tela

var _painel: Panel
var _texto: Label
var _usadas: Array[int] = []


func _ready() -> void:
	_montar_ui()
	_agendar_mensagens()


func _montar_ui() -> void:
	position = Vector2(860, 8)
	size = Vector2(360, 78)
	modulate = Color(1, 1, 1, 0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(0.09, 0.03, 0.14, 0.92)
	estilo.border_width_left = 2
	estilo.border_width_top = 2
	estilo.border_width_right = 2
	estilo.border_width_bottom = 2
	estilo.border_color = Color(0.78, 0.35, 0.95, 0.9)
	estilo.corner_radius_top_left = 12
	estilo.corner_radius_top_right = 12
	estilo.corner_radius_bottom_right = 12
	estilo.corner_radius_bottom_left = 12
	estilo.shadow_color = Color(0.78, 0.35, 0.95, 0.35)
	estilo.shadow_size = 10

	_painel = Panel.new()
	_painel.size = size
	_painel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_painel.add_theme_stylebox_override("panel", estilo)
	add_child(_painel)

	var remetente := Label.new()
	remetente.text = "founder  ·  slack"
	remetente.position = Vector2(14, 8)
	remetente.size = Vector2(332, 20)
	remetente.add_theme_color_override("font_color", Color(0.78, 0.55, 0.95))
	remetente.add_theme_font_size_override("font_size", 13)
	_painel.add_child(remetente)

	_texto = Label.new()
	_texto.position = Vector2(14, 28)
	_texto.size = Vector2(332, 44)
	_texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_texto.add_theme_color_override("font_color", Color(0.95, 0.92, 1.0))
	_texto.add_theme_font_size_override("font_size", 14)
	_painel.add_child(_texto)


# divide a duração em N janelas e sorteia um instante dentro de cada uma,
# garantindo espaçamento mínimo (2-3 mensagens bem distribuídas, não em
# cima uma da outra)
func _agendar_mensagens() -> void:
	var n: int = clampi(qtd_mensagens, 1, FALAS.size())
	var janela: float = duracao_partida / float(n)
	for i in range(n):
		var inicio: float = janela * i + janela * 0.15
		var fim: float = janela * (i + 1) - tempo_visivel - 0.3
		var t: float = randf_range(inicio, maxf(inicio, fim))
		get_tree().create_timer(t).timeout.connect(_mostrar_mensagem)


func _mostrar_mensagem() -> void:
	if not is_inside_tree():
		return
	_texto.text = FALAS[_sortear_fala()]

	position.y = -20
	modulate = Color(1, 1, 1, 0)

	var tw := create_tween()
	tw.tween_property(self, "position:y", 8.0, 0.35)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(self, "modulate:a", 1.0, 0.25)
	tw.tween_interval(tempo_visivel)
	tw.tween_property(self, "modulate:a", 0.0, 0.4)


func _sortear_fala() -> int:
	if _usadas.size() >= FALAS.size():
		_usadas.clear()
	var idx: int = randi() % FALAS.size()
	while _usadas.has(idx):
		idx = randi() % FALAS.size()
	_usadas.append(idx)
	return idx
