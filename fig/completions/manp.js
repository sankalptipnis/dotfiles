var e={name:"manp",description:"Open the manual pages in preview",args:{generators:{script:"ls -1 $(man -w | sed 's#:#/man1 #g') | cut -f 1 -d . | sort | uniq",postProcess:n=>n.split(`
`).filter(t=>!(t.length==0||t.startsWith("/"))).map(t=>({name:t,description:"Man page",icon:"fig://icon?type=string"}))}}},r=e;export{r as default};
