#!/bin/bash

# Imposta il valore iniziale dell'incremento
increment=1

# Trova tutti i file con estensione .feature nella directory corrente e nelle sottodirectory
find . -type f -name "*.feature" -print0 | while IFS= read -r -d '' file; do
  # Ottieni il primo rigo del file
  first_line=$(head -n 1 "$file")

  # Aggiungi l'incremento alla fine del primo rigo
  modified_line="$first_line $increment"

  # Aggiorna il file con il primo rigo modificato, utilizzando un delimitatore diverso da '/'
  sed -i "1s|.*|$modified_line|" "$file"

  # Incrementa il valore per il prossimo file
  ((increment++))
done

echo "Modifica completata!"

