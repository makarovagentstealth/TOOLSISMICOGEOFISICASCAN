# Check if jq and bc commands are available
if ! command -v jq &> /dev/null; then
  echo "Error: jq command not found. Please install jq (https://stedolan.github.io/jq/)"
  exit 1
fi

if ! command -v bc &> /dev/null; then  
  echo "Error: bc command not found. Please install bc (usually included in most Linux distributions)"
  exit 1
fi

# Carregar dados do sismo do arquivo payload.json
dados_sismo=$(jq -r . payload.json)

# Extrair valores das variáveis (assuming valid json)
magnitude_base=$(echo "${dados_sismo}" | jq -r '.magnitude_base')
incerteza_posicao=$(echo "${dados_sismo}" | jq -r '.incerteza_posicao')
incerteza_momento=$(echo "${dados_sismo}" | jq -r '.incerteza_momento')
estados_possiveis=$(echo "${dados_sismo}" | jq -r '.estados_possiveis[]')
padrao_magnetico=$(echo "${dados_sismo}" | jq -r '.padrao_magnetico')
entanglement_presente=$(echo "${dados_sismo}" | jq -r '.entanglement_presente')

# Check if any variable extraction failed
if [[ -z "$magnitude_base" || -z "$incerteza_posicao" || -z "$incerteza_momento" || -z "$estados_possiveis" || -z "$padrao_magnetico" || -z "$entanglement_presente" ]]; then
  echo "Error: Failed to extract data from payload.json. Please check the format."
  exit 1
fi

# Rest of the script...
magnitude_previsao=$(echo "$magnitude_base + $incerteza_posicao + $incerteza_momento" | bc)
echo "Magnitude prevista do abalo sísmico: ${magnitude_previsao}"
