
var GridOverlay = GridOverlay || {};
var grid;
var main;
var typographyEnabled = false;
var tags = [
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  '.h1',
  '.h2',
  '.h3',
  '.h4',
  '.h5',
  '.h6',
  '.d1',
  '.d2',
  '.d3',
  '.d4',
  'p',
  'li',
  '.cta'
];

GridOverlay.testlineheight = GridOverlay.testlineheight || {};

/**
 * Toggle the light height for testing
 */
GridOverlay.testlineheight.toggleLineHeight = function() {
    var i = tags.length - 1;
    var j;
    var tag;
    var elems;
    var elem;

    for (; i >= 0; i--) {
        tag = tags[i];
        elems = document.querySelectorAll(tag);
        j = elems.length - 1;

        for (; j >= 0; j--) {
            elem = elems[j];

            if (typographyEnabled) {
                elem.classList.remove('test-lineheight');
            } else {
                elem.classList.add('test-lineheight');
            }
        }
    }

    typographyEnabled = (typographyEnabled) ? false : true;
};

GridOverlay.testgrid = GridOverlay.testgrid || {};

/**
 * Return the number of grid columns for a given breakpoint
 * @return {number} the number of columns
 */
GridOverlay.testgrid.getNumberOfColumns = function() {
    var mobile = window.matchMedia('(max-width: 767px)').matches;
    var cols = 12;

    if (mobile) {
        cols = 6;
    }

    return cols;
};

/**
 * Insert the test-grid element into the DOM
 */
GridOverlay.testgrid.insertGrid = function() {
    var body = document.querySelector('body');

    grid = document.createElement('div');
    grid.classList.add('test-grid');
    body.appendChild(grid);
};

/**
 * Insert the test-grid_main element into the DOM
 */
GridOverlay.testgrid.insertMain = function() {
    main = document.createElement('div');
    main.classList.add('test-grid_main');
    main.classList.add('cols');
    grid.appendChild(main);
};

/**
 * Insert the columns into the DOM
 */
GridOverlay.testgrid.insertColumns = function() {
    var cols = GridOverlay.testgrid.getNumberOfColumns();
    var col;
    var i = cols - 1;

    for (; i >= 0; i--) {
        col = document.createElement('div');
        col.classList.add('col');
        main.appendChild(col);
    }
};

/**
 * Remove the columns from the DOM
 * @param {function} cb the callback function
 */
GridOverlay.testgrid.removeColumns = function(cb) {
    var cols = main.querySelectorAll('.col');
    var i = cols.length - 1;

    for (; i >= 0; i--) {
        main.removeChild(cols[i]);
    }

    if (cb) {
        cb();
    }
};

/**
 * Update the number of columns
 */
GridOverlay.testgrid.updateColumns = function() {
    GridOverlay.testgrid.removeColumns(GridOverlay.testgrid.insertColumns);
};

/**
 * Adds the Grid to the DOM
 */
GridOverlay.testgrid.addGrid = function() {
    GridOverlay.testgrid.insertGrid();
    GridOverlay.testgrid.insertMain();
    GridOverlay.testgrid.insertColumns();
    window.addEventListener('resize', GridOverlay.debounce(
        GridOverlay.testgrid.updateColumns, 300));
};

/**
 * Removes the Grid to the DOM
 */
GridOverlay.testgrid.removeGrid = function() {
    document.body.removeChild(grid);
    window.addEventListener('resize', GridOverlay.debounce(
        GridOverlay.testgrid.updateColumns, 300));
};

/**
 * Toggles the grid for testing
 */
GridOverlay.testgrid.toggleGrid = function() {
    if (document.querySelector('.test-grid')) {
        GridOverlay.testgrid.removeGrid();
    } else {
        GridOverlay.testgrid.addGrid();
    }
};

/**
 * Debounce events
 *
 * @param {function} func function you wish to execute
 * @param {number} wait time in millisections
 * @param {boolean} immediate trigger function at beginning instead of end
 * @return {function} debounced function
 */
GridOverlay.debounce = function(func, wait, immediate) {
    var timeout;

    return function() {
        var context = this;
        var args = arguments;

        var later = function() {
            timeout = null;
            if (!immediate) {
                func.apply(context, args);
            }
        };
        var callNow = immediate && !timeout;

        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) {
            func.apply(context, args);
        }
    };
};

/**
 * Get ancestor element by class name
 *
 * @param {element} el element whose parent you wish to find
 * @param {string} cl class on the parent you wish to find
 * @return {element} ancestor of element
 */
GridOverlay.getAncestorByClass = function(el, cl) {
    var parent = el;

    do {
        parent = parent.parentNode;
    } while (!parent.classList.contains(cl));

    return parent;
};
