window.QueryTree = class QueryTree

  constructor: ->
    @statusField = $('#advanced_search_status')
    @container   = $('#advanced-search-tree')
    @initTree()
    Menu.initMenus()


  @activeInput: ->
    $(document.activeElement).hasClass('clause-input')


  @generateKey: ->
    '_' + new Date().getTime()


  initTree: ->
    json = @statusField.val() || ''
    data = if (json == '')
             { children: [ { key: 'query-root', isFolder: true, expand: true, children: [{key: QueryTree.generateKey()}]} ] }
           else
             JSON.parse(json)
    @container.dynatree  $.extend {}, QueryTreeOptions.defaults, data
    @tree = @container.dynatree('getTree')


  addChildTo: (parent, data) ->
    parent.addChild(data)
    parent.expand(true)
    parent.render()


  addNewClause: (parent) ->
    @addChildTo parent, {key: QueryTree.generateKey()}


  addNewGroup: (parent) ->
    @addChildTo parent, key: QueryTree.generateKey(), isFolder: true, expand: true


  update: ->
    @setStatus()
    @setQueryField()


  setStatus: ->
    status = @tree.toDict()
    @statusField.val JSON.stringify(status)


  reset: ->
    @statusField.val ''
    @initTree()
    @tree.reload()


  setQueryField: ->
    query = @tree.getNodeByKey('query-root').data.query.toQuery()
    facetSearchPanel.updateQueryField query


$ ->
  window.queryTree = new QueryTree
