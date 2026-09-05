#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

DB_FILE="/etc/tiendassh/resellers.db"
mkdir -p /etc/tiendassh
[ ! -f "$DB_FILE" ] && touch "$DB_FILE"

while true; do
    clear
    echo -e "${NEON_BLUE}==========================================${NC}"
    echo -e "${NEON_GREEN}      💼 SISTEMA DE REVENTA / REVENDEDORES${NC}"
    echo -e "${NEON_BLUE}==========================================${NC}"
    echo -e "${WHITE}[1]${NC} Crear revendedor"
    echo -e "${WHITE}[2]${NC} Asignar saldo de cuentas"
    echo -e "${WHITE}[3]${NC} Lista y detalles de revendedores"
    echo -e "${WHITE}[4]${NC} Remover revendedor"
    echo -e "${WHITE}[0]${NC} Volver"
    echo -e "${NEON_BLUE}==========================================${NC}"
    read -p "Selecciona una opción: " opt

    case $opt in
        1)
            read -p "Nombre del revendedor: " name
            if [ -z "$name" ]; then echo -e "${RED}❌ Nombre inválido.${NC}"; sleep 1; continue; fi
            key=$(echo "$name-$(date +%s)" | md5sum | cut -d' ' -f1)
            read -p "Cantidad de cuentas a asignar (ej. 50): " credits
            if ! [[ "$credits" =~ ^[0-9]+$ ]]; then credits=50; fi
            echo "$name|$key|$credits|0" >> "$DB_FILE"
            echo -e "${NEON_GREEN}✅ Revendedor '$name' creado con Key: $key y $credits cuentas.${NC}"
            read -p "Presiona Enter..." ;;
        2)
            read -p "Nombre del revendedor a recargar: " name
            if ! grep -q "^$name|" "$DB_FILE"; then echo -e "${RED}❌ Revendedor no encontrado.${NC}"; sleep 1; continue; fi
            read -p "Cuentas adicionales a agregar: " add_credits
            if ! [[ "$add_credits" =~ ^[0-9]+$ ]]; then add_credits=0; fi
            
            line=$(grep "^$name|" "$DB_FILE")
            key=$(echo "$line" | cut -d'|' -f2)
            curr_c=$(echo "$line" | cut -d'|' -f3)
            used_c=$(echo "$line" | cut -d'|' -f4)
            new_c=$((curr_c + add_credits))
            
            sed -i "/^$name|/d" "$DB_FILE"
            echo "$name|$key|$new_c|$used_c" >> "$DB_FILE"
            echo -e "${NEON_GREEN}✅ Saldo actualizado. Nuevo total: $new_c cuentas.${NC}"
            read -p "Presiona Enter..." ;;
        3)
            clear
            echo -e "${NEON_BLUE}==========================================${NC}"
            printf "%-15s %-32s %-12s %-12s\n" "REVENDEDOR" "KEY" "DISPONIBLES" "USADAS"
            echo "----------------------------------------------------------------------"
            while IFS='|' read -r r_name r_key r_avail r_used; do
                if [ -n "$r_name" ]; then
                    printf "%-15s %-32s %-12s %-12s\n" "$r_name" "$r_key" "$r_avail" "$r_used"
                fi
            done < "$DB_FILE"
            echo -e "${NEON_BLUE}==========================================${NC}"
            read -p "Presiona Enter..." ;;
        4)
            read -p "Nombre del revendedor a eliminar: " name
            sed -i "/^$name|/d" "$DB_FILE"
            echo -e "${NEON_GREEN}✅ Revendedor eliminado.${NC}"
            read -p "Presiona Enter..." ;;
        0) break ;;
        *) echo -e "${RED}❌ Opción inválida${NC}"; sleep 1 ;;
    esac
done
