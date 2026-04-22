let myHandler = async function (event, context, callback, logger) {
    logger.info(`Input event: ${JSON.stringify(event)}`);

    let appInfo = {
        bannerList: ['CateringOrderTemplate/good_spec_logo1.png', 'CateringOrderTemplate/good_spec_logo2.png'],
        imgBaseUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/test-1pvkp/',
        telephone: '10000000001',
    }
    logger.info(`appInfo: ${appInfo}`);
    let tableList = [{
        id: '1',
        tableName: '1号桌',
        typeName: '小桌',
        num: '1',
        status: '0'
    }, {
        id: '2',
        tableName: '2号桌',
        typeName: '小桌',
        num: '2',
        status: '0'
    }, {
        id: '3',
        tableName: '3号桌',
        typeName: '中桌',
        num: '3',
        status: '0'
    }, {
        id: '4',
        tableName: '4号桌',
        typeName: '中桌',
        num: '4',
        status: '0'
    }, {
        id: '5',
        tableName: '5号桌',
        typeName: '大桌',
        num: '5',
        status: '0'
    }, {
        id: '6',
        tableName: '6号桌',
        typeName: '大桌',
        num: '6',
        status: '0'
    }, {
        id: '7',
        tableName: '7号桌',
        typeName: '大桌',
        num: '7',
        status: '0'
    }, {
        id: '8',
        tableName: '8号桌',
        typeName: '大桌',
        num: '8',
        status: '0'
    }, {
        id: '9',
        tableName: '9号桌',
        typeName: '大桌',
        num: '9',
        status: '0'
    }, {
        id: '10',
        tableName: '10号桌',
        typeName: '大桌',
        num: '10',
        status: '0'
    }]
    logger.info(`tableList: ${tableList}`);
    let result = { appInfo, tableList }
    let res = new context.HTTPResponse(result, {
        "faas-content-type": "json"
    }, "application/json", "200");

    callback(res);
};

module.exports.myHandler = myHandler;