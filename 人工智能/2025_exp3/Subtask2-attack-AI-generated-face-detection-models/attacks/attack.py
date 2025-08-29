import numpy as np
import os
import sys
sys.path.append('../')
import glob
from PIL import Image
import random
import copy
import torch
import torch.nn as nn
from torchvision import transforms
import torch.nn.functional as F
from models import VGGNet,AlexNet,MobileNetV2
import argparse

parser = argparse.ArgumentParser(description='Adversarial attacks on face images')
parser.add_argument('--input_dir', type=str, default='', help='input directory.')
parser.add_argument('--output_dir', type=str, default='', help='output directory.')
parser.add_argument('--gpu_id', type=str, default='0', help='GPU ID')
parser.add_argument('--model_num', type=int, default=1, help='model to attack.') 
parser.add_argument('--ckpt_alexnet', type=str, default="../checkPoint/AlexNet/model.pth", help='path to AlexNet model.')
parser.add_argument('--ckpt_vggnet', type=str, default="../checkPoint/VGGNet/model.pth", help='path to VGGNet model.')
parser.add_argument('--ckpt_mobilenet', type=str, default="../checkPoint/MobNet/model.pth", help='path to MobileNetV2 model.')
parser.add_argument('--max_epsilon', type=int, default=2, help='maximum perturbation.')
parser.add_argument('--num_iter', type=int, default=10, help='number of iterations.')
parser.add_argument('--image_format', type=str, default='png', help='image format.')
parser.add_argument('--image_width', type=int, default=128, help='width of image.')
parser.add_argument('--image_height', type=int, default=128, help='height of image.')
parser.add_argument('--momentum', type=float, default=1.0, help='momentum.')
args = parser.parse_args()

os.environ['CUDA_VISIBLE_DEVICES'] = args.gpu_id
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

output_dir = args.output_dir + 'src_m' + str(args.model_num) + '_eps_' + str(args.max_epsilon) + '/'
os.makedirs(output_dir, exist_ok=True)

preprocess = transforms.ToTensor()


def get_file_list(dataset_dir):
    file_list = glob.glob(os.path.join(dataset_dir, '*.png')) + glob.glob(os.path.join(dataset_dir, '*.jpg'))
    file_list.sort()
    return file_list
    

def read_image(img_path):
    img = Image.open(img_path)
    img_tensor = preprocess(img)
    input_tensor = img_tensor.unsqueeze(0)
    return input_tensor


def save_image(img_tensor, img_name, save_path):    
    img = img_tensor.squeeze(0)        
    img = img.detach().cpu().numpy()   
    img = img.transpose(1,2,0)
    img = np.clip(img * 255, 0, 255) 
    img = img.astype("uint8")
    img = Image.fromarray(img)
    img_save_path = save_path + img_name + '.png'
    img.save(img_save_path, "PNG")


# load model for attack
def load_model(model_path, net):
    "load pretrained model to network"
    model = net().to(device)
    model.load_state_dict(torch.load(model_path, map_location='cpu'))   
    return model

if args.model_num == 1:
    model = load_model(args.ckpt_alexnet, AlexNet)
if args.model_num == 2:
    model = load_model(args.ckpt_vggnet, VGGNet)
if args.model_num == 3:
    model = load_model(args.ckpt_mobilenet, MobileNetV2)

model.eval()


img_lists = get_file_list(args.input_dir)

# create label tensor
folder_name = args.input_dir
imgs_label = folder_name.split('/')[-2]

if imgs_label.split('_')[-1] == 'real':
    img_label_tensor = torch.Tensor([1]).long()
elif imgs_label.split('_')[-1] == 'fake':
    img_label_tensor = torch.Tensor([0]).long()
else:
    raise ValueError('check folder name')


def get_file_name(img_path, img_type=args.image_format):
    if img_type == 'png':
        img_name = img_path.split('.png')[-2].split('/')[-1]
    elif img_type == 'jpg':
        img_name = img_path.split('.jpg')[-2].split('/')[-1]
    else:
        raise ValueError('check image format.')
    return img_name
        



## perform MI-FGSM attack: write your MI-FGSM attack function here
# def mifgsm_attack()
    




# perform attack
max_val = 1.
min_val = 0.
epsilon = args.max_epsilon/ 255.
criterion = nn.CrossEntropyLoss(reduction="sum").to(device)

print('\n============================================================================')
print(args)
print('\n Attacking face images from directory: %s'%(args.input_dir))
print('============================================================================\n')

for img_idx, img_path in enumerate(img_lists):
    img = read_image(img_path).to(device)
    img.requires_grad = True
        
    img_name = get_file_name(img_path, img_type=args.image_format)
    img_label = img_label_tensor.to(device) 
    print('attacking image: %s' %(img_name+'.png'))   
    ## conduct mifgsm attack here (write your mi-fgsm function)
    # img_adv = mifgsm_attack(img, img_label, model, epsilon)  
    # save_image(img_adv, img_name, output_dir)
    
print('\n============================================================================')
print('attacked face images have been saved in %s \n'%(output_dir))

        
     