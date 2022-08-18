# profile_on-down
# Script para automatizar a remocao de regras de mangle e rotas criadas pelo evento On-Up
# Development by: Jayron Castro
# Date: 18/08/2022 18:42
# eMail: jayroncastro@gmail.com
{
  #Armazena o nome da interface
  :local interfaceName [/interface ethernet get $interface name];

  #Remove tabela de rota especifica do link pppoe
  /ip route remove [find routing-mark="out_$interfaceName"];

  #Remove regras mangle para marcacao de rotas
  /ip firewall mangle remove [find new-routing-mark="out_$interfaceName"];

  #Remove regras mangle de marcacao de conexao
  /ip firewall mangle remove [find new-connection-mark="in_$interfaceName"];
}