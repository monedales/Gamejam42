# CyberTerapia™ — protótipo de hackathon (Godot 4)

Co-op local no mesmo teclado: dois jogadores tratam o burnout do João, um dev júnior que literalmente "caiu em produção" depois de vibe-codar demais numa startup insuportavelmente otimista.

- **Lado RACIONAL** (esquerda) → minigame de ritmo, teclas **A S D**
- **Lado EMOCIONAL** (direita) → estabilizar as ondas, teclas **J K L**
- **Glitch (a mecânica-assinatura):** de vez em quando um lado trava. Só o
  **outro jogador** conserta — segurando **W** (conserta o lado direito) ou
  **I** (conserta o lado esquerdo) — enquanto ainda joga o próprio minigame.
- **Notificações do chefe:** durante a partida, 2-3 "mensagens de Slack" do founder
  pipocam no canto da tela com falas dele (banco completo em `HISTORIA.md`) — puramente
  cosméticas, não afetam o gameplay.

---

## Como rodar
1. Instale o **Godot 4.x** (4.7 recomendado) — `brew install --cask godot` no Mac, ou baixe em godotengine.org.
2. Abra o Godot → **Importar** → selecione o `project.godot` desta pasta (ou rode `godot project.godot` direto no terminal).
3. Aperte **F5**. Pronto.

## Loop do jogo
1. **Menu** → sequência de telas de lore (o chefe pressionando o João pro deploy).
2. **Tutorial 1** — Waves sozinho, aprende **J K L**.
3. **Tutorial 2** — Dance sozinho, aprende **A S D**.
4. **Partida (Hub)** — os dois jogam ao mesmo tempo por 60s, um de cada lado, lidando com os
   glitches que aparecem no lado do colega (e as notificações do chefe pipocando no canto).
5. **Final** — depende da diferença entre os scores dos dois lados:
   - Diferença pequena (< 10%) → **Integração** (final bom)
   - Racional bem maior → **Razão Ganhou**
   - Emocional bem maior → **Emoção Ganhou**
   - Um dos dois colapsa (emocional muito baixo) → **Derrota**

## Onde mexer pra balancear
- `scripts/Hub.gd` — duração da partida (`DURACAO`), limites dos finais (`COLAPSO_MIN`, `VAR_LIMITE`).
- `scripts/GlitchManager.gd` — ritmo de spawn dos glitches (`SPAWN_MIN`/`SPAWN_MAX`), tempo de conserto (`HOLD_TIME`).
- `scripts/MinigameDance.gd` / `scripts/MinigameWaves.gd` — dificuldade de cada minigame (BPM, janelas de acerto, drenagem de foco).
- `scripts/ChefeMensagem.gd` — quantidade/frequência das notificações do chefe (`qtd_mensagens`, `tempo_visivel`) e o banco de falas (`FALAS`).

## Ideias de extensão
1. Ligar a tela **PlotTwist** ("chama o colega") no fluxo — hoje existe mas não tá encadeada nos tutoriais.
2. Avatar do chefe nas notificações (hoje é só texto).
3. Export pra Web (HTML5) pra rodar direto no navegador — o renderer já tá em GL Compatibility pra isso.

---

Documento de narrativa completo (personagens, falas do chefe, os 4 finais) em [`HISTORIA.md`](./HISTORIA.md).
