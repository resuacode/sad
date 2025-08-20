# Script para limpiar caché de Docusaurus
# Ejecutar cuando notes problemas de caché

echo "🧹 Limpiando caché de Docusaurus..."
npm run clear

echo "🧹 Limpiando caché de npm..."
npm cache clean --force

echo "🗑️ Eliminando carpetas temporales..."
rm -rf .docusaurus
rm -rf node_modules/.cache
rm -rf build

echo "✅ Limpieza completada. Ahora puedes ejecutar 'npm run start' o 'npm run build'"
