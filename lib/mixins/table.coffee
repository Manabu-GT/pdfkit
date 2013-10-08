module.exports =
    table: (data, headers, options) ->
        options = @_extendOptions(options)
        this.x = options.margins.left
        this.y = options.margins.top

        # Draws table headers
        if not options.headers.hidden
            this.fontSize(options.headers.font_size)
            for header in headers
                this.y = options.margins.top
                this.text(header.name,
                    width: header.width
                    align: options.headers.align)
                #console.log('doc.x:' + this.x)
                #console.log('doc.y:' + this.y)
                this.rect(this.x, options.margins.top, header.width, this.y - options.margins.top).stroke()
                this.x += header.width

        # Draws table data below headers
        this.fontSize(options.data.font_size)
        for row_data in data
            nextColumnHeight = options.data.column_height or this.currentLineHeight()
            if this.y + nextColumnHeight > this.page.height - options.margins.bottom
                this.addPage()
                this.y = this.page.margins.top
            this.x = options.margins.left
            currentY = this.y
            for header, i in headers
                this.y = currentY
                # vertical align center
                if options.data.column_height > 0
                    this.y += (options.data.column_height - this.currentLineHeight())/2
                this.text(row_data[i],
                    width: header.width
                    align: options.data.align)
                this.rect(this.x, currentY, header.width,
                    if options.data.column_height > 0 then options.data.column_height else this.y - currentY).stroke()
                this.x += header.width
            if options.data.column_height > 0
                this.y = currentY + options.data.column_height

        return this

    _defaultOptions: ->
        return {
            margins:
                left: this.page.margins.left
                top: this.page.margins.top
                right: this.page.margins.right
                bottom: this.page.margins.bottom
            headers:
                hidden: false
                font_size:12
                align:'center'
                paddings:
                    left: 0
                    top: 0
                    right: 0
                    bottom: 0
            data:
                font_size:12
                align:'center'
                paddings:
                    left: 0
                    top: 0
                    right: 0
                    bottom: 0}

    _extendOptions: (options = {}) ->
        my_options = @_extend(@_defaultOptions(), options)
        return my_options

    _extend: (target, source) ->
        for prop of source
            if typeof source[prop] is 'object'
                target[prop] = @_extend(target[prop], source[prop])
            else
                target[prop] = source[prop]

        return target