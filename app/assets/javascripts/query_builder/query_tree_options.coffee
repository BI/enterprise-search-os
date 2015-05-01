window.QueryTreeOptions = class QueryTreeOptions

  @defaults:
    debugLevel:      0
    onQueryActivate: (node) -> false
    onQuerySelect:   (node) -> false
    keyboard:        false
    clickFolderMode: 1

    fx:
      height:   'toggle'
      duration: 300

    onCustomRender: (node) ->
      node.data.query = new (node.data.isFolder && QueryGroup || QueryClause) node
      node.data.query.render()

    onRender: (node, nodeSpan) ->
      $(nodeSpan).find('.query-item').hover(
        -> $(this).addClass('hovered-query-item') unless queryTree.isDragging == true || QueryTree.activeInput()
        -> $(this).removeClass('hovered-query-item') unless $(document.activeElement).is( $(this) )
      )
      return if node.data.isFolder
      new ClauseInput node, nodeSpan
      node.data.query.containerFeedback(node)

    onExpand: (flag, node) ->
      node.render() if flag # resize input
      queryTree.setStatus()

    dnd:
      onDragStart: (node) ->
        # This function MUST be defined to enable dragging for the tree.
        # Return false to cancel dragging of node.
        #logMsg("tree.onDragStart(%o)", node)

        queryTree.isDragging = true
        # prevent dragging the first node (which we use as root)
        # return false if node.data.key == 'query-root'
        true

      onDragStop: (node) ->
        queryTree.isDragging = false

      autoExpandMS: 500

      # Prevent dropping nodes 'before self', etc.
      preventVoidMoves: true

      onDragEnter: (node, sourceNode) ->
        # sourceNode may be null for non-dynatree droppables.
        # Return false to disallow dropping on node. In this case
        # onDragOver and onDragLeave are not called.
        # Return 'over', 'before, or 'after' to force a hitMode.
        # Return ['before', 'after'] to restrict available hitModes.
        # Any other return value will calc the hitMode from the cursor position.
        #logMsg("tree.onDragEnter(%o, %o)", node, sourceNode)

        # prevent creating siblings of first node (which we use as root node)
        return 'over' if node.data.key == 'query-root'
        # prevent dropping a parent below it's own child
        return false if node.isDescendantOf(sourceNode)
        # prevent creating childs in non-folders (allows only before and after for non-folders)
        return ['before', 'after'] unless node.data.isFolder
        true

      onDrop: (node, sourceNode, hitMode, ui, draggable) =>
        # This function MUST be defined to enable dropping of items on the tree.
        #logMsg("tree.onDrop(%o, %o, %s)", node, sourceNode, hitMode)

        sourceNode.move(node, hitMode)
        node.render()
        node.expand(true)
        sourceNode.expand(true)
        queryTree.update()
