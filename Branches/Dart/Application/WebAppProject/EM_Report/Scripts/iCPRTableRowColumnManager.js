// ======== EXPAND / COLLAPSE PORTFOLIO ROWS ============
var numberOfTherapyRows = 6;
var numberOfLumpSumRows = 11;
function registerPortfolioRowsAction(iframe) {
    $('table[alt^="portfolio"]').each(function () {
        //var type = getPortfolioTableType($(this));

        // for therapy treatments   
        var therapyTreatmentRow = $(this).find('div[alt="therapy_treat"]').closest('tr');
        //therapyTreatmentRow.attr('data-isExpanded', '0');
        therapyTreatmentRow.css('cursor', 'pointer');
        therapyTreatmentRow.click(function () {
            toggleDetailedRows($(this), numberOfTherapyRows, iframe);
        });

        // for lump sum intimations
        var lumpSumRow = $(this).find('div[alt="lump_sum_int"]').closest('tr');
        //lumpSumRow.attr('data-isExpanded', '0');
        lumpSumRow.css('cursor', 'pointer');
        lumpSumRow.click(function () {
            toggleDetailedRows($(this), numberOfLumpSumRows, iframe);
        });
    });
}

function toggleDetailedRows(row, numberOfRows, iframe) {
    var isExpanded = row.attr('data-isExpanded');
    if (isExpanded == 0) {
        showDetailedRows(row, numberOfRows, iframe);
    }
    else {
        hideDetailedRows(row, numberOfRows, iframe);
    }
}

function showDetailedRows(row, numberOfRows, iframe) {
    row.attr('data-isExpanded', '1');
    row.nextAll('tr:lt(' + numberOfRows + ')').show();
    var expandHeight = (row.siblings("tr:eq(3)").height()) * numberOfRows;
    adjustPortfolioContainerHeight(expandHeight, iframe);


    if (document.documentMode == 7 || document.documentMode == 8) {
        var divHeight = row.closest('div').height();

        var rowType = row.find('td:eq(1) div').attr('alt');
        if (rowType == 'therapy_treat') {
            row.closest('div').height(divHeight + expandHeight);
        }
        else if (rowType == 'lump_sum_int') {
            row.closest('div').height(divHeight + expandHeight + 25);
        }
    }

    forceIE8RefreshHeight();
}

function hideDetailedRows(row, numberOfRows, iframe) {
    row.attr('data-isExpanded', '0');
    row.nextAll('tr:lt(' + numberOfRows + ')').hide();
    var collapseHeight = (row.siblings("tr:eq(3)").height()) * numberOfRows * -1;
    adjustPortfolioContainerHeight(collapseHeight, iframe);

    if (document.documentMode == 7 || document.documentMode == 8) {
        var divHeight = row.closest('div').height();

        var rowType = row.find('td:eq(1) div').attr('alt');
        if (rowType == 'therapy_treat') {
            row.closest('div').height(divHeight + collapseHeight);
        }
        else if (rowType == 'lump_sum_int') {
            row.closest('div').height(divHeight + collapseHeight - 25);
        }
    }

    forceIE8RefreshHeight();
}

// adjust portfolio container height when expand/collapse
function adjustPortfolioContainerHeight(ammount, iframe) {
    //var iframe;
    //if (document.URL.toLowerCase().indexOf('level2') > 0) {
    //    iframe = $('iframe#ifReport_Agency', window.parent.document);
    //}
    //else {
    //    iframe = $('iframe#ifReport', window.parent.document);
    //}
    
    var iframeHeight = iframe.height() + ammount;
    iframe.height(iframeHeight);
    $('#divViewer').height(iframeHeight);
    $('#rvwReportViewer').height(iframeHeight);
    $('#rvwReportViewer_ct109').closest('td').height(iframeHeight);
}

//function hideDetailedRowsByDefault() {
//    $('table[alt^="portfolio"]').each(function () {
//        var type = getPortfolioTableType($(this));

//        var therapyTreatmentRow = $(this).find('div[alt="therapy_treat"]').closest('tr');
//        var lumpSumRow = $(this).find('div[alt="lump_sum_int"]').closest('tr');
//        hideDetailedRows(therapyTreatmentRow, type, numberOfTherapyRows);
//        hideDetailedRows(lumpSumRow, type, numberOfLumpSumRows);
//    });
//}

function hideDetailedRowsByDefault(portfolioTable, iframe) {
    var therapyTreatmentRow = portfolioTable.find('div[alt="therapy_treat"]').closest('tr');
    var lumpSumRow = portfolioTable.find('div[alt="lump_sum_int"]').closest('tr');
    hideDetailedRows(therapyTreatmentRow, numberOfTherapyRows, iframe);
    hideDetailedRows(lumpSumRow, numberOfLumpSumRows, iframe);
}

// fix height issue in IE 8
function forceIE8RefreshHeight() {
    if (document.documentMode == 7 || document.documentMode == 8) {
        $("table[alt^='portfolio']").each(function () {
            $(this).closest('td').attr('style', '');
        });
    }
}
// ======== END EXPAND / COLLAPSE PORTFOLIO ROWS ============
