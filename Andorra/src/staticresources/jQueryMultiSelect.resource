/* ------------------------------------------------------------
ALJS Multi Select
------------------------------------------------------------ */
if (typeof jQuery === "undefined") { throw new Error("Appiphony Lightning JS requires jQuery") }

(function($) {
    var picklistItemMarkup = 
    '<li draggable="true" id="{{optionId}}" class="slds-picklist__item slds-has-icon slds-has-icon--left" aria-selected="false" tabindex="0" role="option">' +
        '<span class="slds-truncate">' +
            '<span>{{optionLabel}}</span>' +
        '</span>' +
    '</li>';

    var aljsMultiSelect = function(el, options) {
        this.$el = $(el);
        this.$selectedContainer = this.$el.find('[data-aljs-multi-select="selected"]').find('ul');
        this.$unselectedContainer = this.$el.find('[data-aljs-multi-select="unselected"]').find('ul');
        this.selectedItems = options.selectedItems;
        this.unselectedItems = options.unselectedItems;
		this.itemsToUnselect = [];
        this.itemsToSelect = [];
        this.settings = options;

        this.init();
    };

    aljsMultiSelect.prototype = {
        constructor: aljsMultiSelect,
        init: function() {
            this.renderUnselectedItems();
            this.renderSelectedItems();

            this.$el.find('[data-aljs-multi-select="unselect"]').on('click', this, this.unselectItem);
            this.$el.find('[data-aljs-multi-select="select"]').on('click', this, this.selectItem);
            this.$el.find('[data-aljs-multi-select="move-up"]').on('click', this, this.moveItemUp);
            this.$el.find('[data-aljs-multi-select="move-down"]').on('click', this, this.moveItemDown);
        },
        renderUnselectedItems: function() {
            var self = this;
            
            this.$unselectedContainer.empty();

            this.unselectedItems.forEach(function(item) {
                self.$unselectedContainer.append(self.createPicklistDomItem(item));
            });

            this.$unselectedContainer
                .off()
                .on('click', 'li', function(e) {
					
					$this = $(this);
					
					var curr = $('li', self.$unselectedContainer).index($this); // get selecting item index
					
					if(e.shiftKey && prev > -1) { // if shift key was pressed and there is previous - select them all
						
						var $itemsToSelect = $('li', self.$unselectedContainer).slice(Math.min(prev, curr), 1 + Math.max(prev, curr));
						
						self.itemsToSelect = [];
						
						$itemsToSelect.each(function() {
							$(this).addClass('slds-is-selected').attr('aria-selected', 'true');
							self.itemsToSelect.push($(this).data('aljs-picklist-obj'));
						});
						
						$('li', self.$unselectedContainer).not($itemsToSelect).each(function() {
							$(this).removeClass('slds-is-selected').attr('aria-selected', 'false');
						});						
							
						prev = -1; // and reset prev
					} else {
						
						prev = curr; // othervise just save prev

						if (e.ctrlKey) {
						
							if ($this.hasClass('slds-is-selected')) {
								$this.removeClass('slds-is-selected').attr('aria-selected', 'false');
								self.itemsToSelect.splice(self.itemsToSelect.indexOf($(this).data('aljs-picklist-obj')), 1);
							} else {
								$this.addClass('slds-is-selected').attr('aria-selected', 'true');
								 self.itemsToSelect.push($(this).data('aljs-picklist-obj'));	
							}
																		
						} else {
							self.itemsToSelect = [];
							$this.addClass('slds-is-selected')
								   .attr('aria-selected', 'true')
								   .siblings()
								   .removeClass('slds-is-selected')
								   .attr('aria-selected', 'false'); 
							 self.itemsToSelect.push($(this).data('aljs-picklist-obj'));							   
						}
					}
										
                   
                })
                .on('dragstart', 'li', function(e) {
                    self.itemsToSelect.push($(this).data('aljs-picklist-obj'));
                
                    e.originalEvent.dataTransfer.setData('text/plain', null);
                })
                .on('dragover', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                })
                .on('dragenter', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                })
                .on('drop', function(e) {
                    e.preventDefault();  
                    e.stopPropagation();
                    self.$el.find('[data-aljs-multi-select="unselect"]').click();
                });
        },
        renderSelectedItems: function() {
            var self = this;
            
            this.$selectedContainer.empty();

            this.selectedItems.forEach(function(item) {
                self.$selectedContainer.append(self.createPicklistDomItem(item));
            });

            this.$selectedContainer
                .off()
                .on('click', 'li', function(e) {
                    
					$this = $(this);
					
					var curr = $('li', self.$selectedContainer).index($this); // get selecting item index
					
					if(e.shiftKey && prev > -1) { // if shift key was pressed and there is previous - select them all
						
						var $itemsToUnselect = $('li', self.$selectedContainer).slice(Math.min(prev, curr), 1 + Math.max(prev, curr));
						
						self.itemsToUnselect = [];
						
						$itemsToUnselect.each(function() {
							$(this).addClass('slds-is-selected').attr('aria-selected', 'true');
							self.itemsToUnselect.push($(this).data('aljs-picklist-obj'));
						});
						
						$('li', self.$selectedContainer).not($itemsToUnselect).each(function() {
							$(this).removeClass('slds-is-selected').attr('aria-selected', 'false');
						});						
							
						prev = -1; // and reset prev
					} else {
						
						prev = curr; // othervise just save prev					
					
						if (e.ctrlKey) {						
							if ($this.hasClass('slds-is-selected')) {
								$this.removeClass('slds-is-selected').attr('aria-selected', 'false');
								self.itemsToUnselect.splice(self.itemsToUnselect.indexOf($(this).data('aljs-picklist-obj')), 1);
							} else {
								$this.addClass('slds-is-selected').attr('aria-selected', 'true');
								 self.itemsToUnselect.push($(this).data('aljs-picklist-obj'));	
							}						
						} else {
							self.itemsToUnselect = [];
							$this.addClass('slds-is-selected')
								   .attr('aria-selected', 'true')
								   .siblings()
								   .removeClass('slds-is-selected')
								   .attr('aria-selected', 'false');
							self.itemsToUnselect.push($(this).data('aljs-picklist-obj')); 
						}
					}
                    
                })
                .on('dragstart', 'li', function(e) {
                    self.itemsToUnselect.push($(this).data('aljs-picklist-obj'));
                    
                    e.originalEvent.dataTransfer.setData('text/plain', null);
                })
                .on('dragover', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                })
                .on('dragenter', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                })
                .on('drop', function(e) {
                    e.preventDefault();  
                    e.stopPropagation();
                    self.$el.find('[data-aljs-multi-select="select"]').click();
                });
        },
        selectItem: function(e) {
            var self = e.data;

            if (self.itemsToSelect.length > 0) {
				
				for (var i = 0; i < self.itemsToSelect.length; i++ ) {
					var item = self.$unselectedContainer.find('#' + self.itemsToSelect[i].id)
						.removeClass('slds-is-selected')
						.attr('aria-selected', 'false')
						.appendTo(self.$selectedContainer);
					
					self.unselectedItems.splice(self.unselectedItems.indexOf(self.itemsToSelect[i]), 1);
					self.selectedItems.push(self.itemsToSelect[i]);
					
					self.settings.onSelectItem(self);
				}
				
				self.itemsToSelect = [];
				self.settings.onSelectItem(self);			
			}
        },
        unselectItem: function(e) {
            var self = e.data;

            if (self.itemsToUnselect.length > 0) {
				
				for (var i = 0; i < self.itemsToUnselect.length; i++ ) {

                    var item = self.$selectedContainer.find('#' + self.itemsToUnselect[i].id)
                        .removeClass('slds-is-selected')
                        .attr('aria-selected', 'false')
                        .appendTo(self.$unselectedContainer);
                    
                    self.selectedItems.splice(self.selectedItems.indexOf(self.itemsToUnselect[i]), 1);
                    self.unselectedItems.push(self.itemsToUnselect[i]);
                }
                self.itemsToUnselect = [];
                self.settings.onUnselectItem(self);
            }
            
        },
        moveItemUp: function(e) {
            var self = e.data;

            if (!self.itemsToUnselect) { return; }

            var itemIndex = self.selectedItems.indexOf(self.itemsToUnselect);

            if (itemIndex > 0) {
                self.selectedItems.splice(itemIndex, 1);
                self.selectedItems.splice(itemIndex - 1, 0, self.itemsToUnselect);

                var $itemToMove = self.$selectedContainer.find('#' + self.itemsToUnselect.id);

                $itemToMove.removeClass('slds-is-selected')
                           .attr('aria-selected', 'false')
                           .insertBefore($itemToMove.prev('li'));

                self.itemsToUnselect = null;
                
                self.settings.onMoveItem(self, 'up');
            }
        },
        moveItemDown: function(e) {
            var self = e.data;

            if (!self.itemsToUnselect) { return; }

            var itemIndex = self.selectedItems.indexOf(self.itemsToUnselect);

            if (itemIndex < self.selectedItems.length - 1) {
                self.selectedItems.splice(itemIndex, 1);
                self.selectedItems.splice(itemIndex + 1, 0, self.itemsToUnselect);

                var $itemToMove = self.$selectedContainer.find('#' + self.itemsToUnselect.id);

                $itemToMove.removeClass('slds-is-selected')
                           .attr('aria-selected', 'false')
                           .insertAfter($itemToMove.next('li'));

                self.itemsToUnselect = null;
                
                self.settings.onMoveItem(self, 'down');
            }
        },
        createPicklistDomItem: function(item) {
            //var $picklistItem = 
            return $(picklistItemMarkup.replace('{{optionId}}', item.id)
                                       .replace('{{optionLabel}}', item.label.toString()))
                                       .data('aljs-picklist-obj', item);
        },
        setSelectedItems: function(objs) {
            this.selectedItems = objs;
            this.renderSelectedItems();
        },
        setUnselectedItems: function(objs) {
            this.unselectedItems = objs;
            this.renderUnselectedItems();
        },
        getSelectedItems: function() {
            return this.selectedItems;
        },
        getUnselectedItems: function() {
            return this.unselectedItems;
        }
    };

    $.fn.aljsMultiSelect = function(options) {
        var multiSelectArguments = arguments;
        var internalReturn;
       // var arguments = arguments;

        var settings = $.extend({
            // These are the defaults
            selectedItems: [],
            unselectedItems: [],
            onSelectItem: function(obj) {},
            onUnselectItem: function(obj) {},
            onMoveItem: function(obj, direction) {}
        }, typeof options === 'object' ? options : {});

        this.each(function() {
            var $this = $(this),
                data = $this.data('aljs-multi-select');

            if (!data) {
                var multiSelectData = new aljsMultiSelect(this, settings);
                $this.data('aljs-multi-select', (data = multiSelectData));
            }
            
            if (typeof options === 'string') {
                internalReturn = data[options](multiSelectArguments[1], multiSelectArguments[2]);
            }
        });

        if (internalReturn === undefined || internalReturn instanceof aljsMultiSelect) {
            return this;
        }

        if (this.length > 1) {
            throw new Error('Using only allowed for the collection of a single element (' + option + ' function)');
        } else {
            return internalReturn;
        }
    }
}(jQuery));