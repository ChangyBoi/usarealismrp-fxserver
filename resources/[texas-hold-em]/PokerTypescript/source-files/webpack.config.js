const webpack = require('webpack');
const path = require('path');

const server = {
    entry: './src/server/server.ts',
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: ['ts-loader'],
                exclude: /node_modules/,
            },
        ],
    },
    plugins: [new webpack.DefinePlugin({ 'global.GENTLY': false })],
    optimization: {
        minimize: false,
    },
    resolve: {
        extensions: ['.tsx', '.ts', '.js'],
    },
    output: {
        filename: '../files/js_compiled/server.js',
        path: path.resolve(__dirname),
    },
    target: 'node',
};

const client = {
    entry: './src/client/client.ts',
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: ['ts-loader'],
                exclude: /node_modules/,
            },
        ],
    },
    optimization: {
        minimize: false,
    },
    resolve: {
        extensions: ['.tsx', '.ts', '.js'],
    },
    output: {
        filename: '../files/js_compiled/client.js',
        path: path.resolve(__dirname),
    },
};

module.exports = [server, client];
