# 🔴 IMPORTANTE: Habilitar Supabase Realtime

Para que el Logistics Hub se actualice automáticamente cuando cambies datos en Supabase, necesitas habilitar **Realtime** en las tablas.

## Opción 1: Usando el SQL Editor (Recomendado)

1. **Ve a tu proyecto en Supabase**: https://supabase.com/dashboard/project/wficuvdsfokzphftvtbi

2. **Abre el SQL Editor**:
   - En el menú lateral izquierdo, haz clic en "SQL Editor"
   - Haz clic en "New query"

3. **Copia y pega este SQL**:

```sql
-- Enable Realtime for bookings table
ALTER PUBLICATION supabase_realtime ADD TABLE public.bookings;

-- Enable Realtime for concierge_assignments table
ALTER PUBLICATION supabase_realtime ADD TABLE public.concierge_assignments;
```

4. **Ejecuta el query**:
   - Haz clic en "Run" (botón verde abajo a la derecha)
   - Deberías ver: "Success. No rows returned"

## Opción 2: Usando la UI (Alternativa)

1. **Ve a Database > Replication** en el menú lateral

2. **Encuentra la tabla `bookings`**:
   - Busca "bookings" en la lista de tablas
   - Haz clic en el toggle "Enable Realtime" (debe ponerse verde)

3. **Encuentra la tabla `concierge_assignments`**:
   - Busca "concierge_assignments" en la lista de tablas
   - Haz clic en el toggle "Enable Realtime" (debe ponerse verde)

## Verificar que funciona

1. **Ejecuta la app** en tu dispositivo/emulador

2. **Abre el Logistics Hub** (tab de logística)

3. **En Supabase Dashboard**:
   - Ve a "Table Editor"
   - Selecciona la tabla `concierge_assignments`
   - Edita cualquier campo (por ejemplo, cambia el nombre del concierge)
   - Guarda los cambios

4. **Verifica en la app**:
   - Los cambios deberían aparecer **automáticamente** sin necesidad de hot reload
   - Si ves los cambios inmediatamente, ¡funciona! 🎉
   - Si necesitas hacer hot reload, revisa los pasos anteriores

## Troubleshooting

### Los cambios no se actualizan automáticamente

**Verifica que Realtime esté habilitado**:
```sql
-- Ejecuta esto en el SQL Editor para verificar
SELECT schemaname, tablename
FROM pg_publication_tables
WHERE pubname = 'supabase_realtime';
```

Deberías ver:
- `public` | `bookings`
- `public` | `concierge_assignments`

### Error: "relation already exists in publication"

Esto significa que Realtime ya está habilitado. ¡Perfecto! No necesitas hacer nada más.

### La app no recibe actualizaciones

1. Verifica que estés conectado a internet
2. Cierra y vuelve a abrir la app
3. Verifica que las credenciales de Supabase sean correctas en `lib/core/secrets/supabase_keys.dart`

## Notas Técnicas

- El código ya está preparado para usar Realtime con `.stream()`
- Los repositoriesimplementan `watchActiveBookingForUser()` y `watchConciergeInfo()`
- El `LogisticsHubController` se suscribe a estos streams automáticamente
- Los cambios se propagan vía WebSocket desde Supabase a la app
