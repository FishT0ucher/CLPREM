

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import warnings
warnings.filterwarnings("ignore")

import os
os.environ["CUDA_VISIBLE_DEVICES"] = "0"

from options import Options
from lib.data import load_data
from lib.timegan import TimeGAN


def train():
    """ Training
    """

    # ARGUMENTS
    opt = Options().parse()

    # LOAD DATA
    ori_data = load_data(opt)

    # LOAD MODEL
    model = TimeGAN(opt, ori_data)

    # TRAIN MODEL
    model.train()

if __name__ == '__main__':
    train()
