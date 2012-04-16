/**
 * moves images based on a reference image.
 * checked image names are stored in a cache file
 *
 * Created for the "fbFaces" Project
 *
 * Author: Jörn Röder // joernroeder.de
 * 
 */
float accuracy = .01; // one percent of all pixels must be the same to identify the image
String referenceImageName = "_noImageReference.jpg";
String defaultImageFolder = "_defaultImage";

String cacheFileName = "_cache.txt";

String folder;
String[] images;
ArrayList<String> unprocessedImages;
ArrayList<String> cachedImages;

String output = "";
  
String title = "";
int movedCount = 0;
String moveTxt = "";

PImage referenceImage;

String cacheFile[];

void setup() {
  size(800  , 150);

  folder = selectFolder("image Folder");
  unprocessedImages = new ArrayList();
  
  // load cache file
  cacheFile = loadStrings(folder + "/" + cacheFileName);
  if (cacheFile == null) {
    //saveStrings(folder + "/" + cacheFileName, "");
  }
  
  // copy to arrayList
  cachedImages = new ArrayList(Arrays.asList(cacheFile));
  println(cachedImages.size());

  // load reference image
  referenceImage = loadImage(folder + "/" + referenceImageName);
  referenceImage.loadPixels();

  File path = new File(folder);
  images = path.list();

  // add images to unprocessed List
  for (int i = 0; i < images.length; i++) {
    // skip other files and referenceImage
    if (images[i].indexOf(".jpg") != -1 && !images[i].equals(referenceImageName) && !inCache(images[i])) {
      unprocessedImages.add(images[i]);
    }
  }

  title = "Compare " + images.length + " images in:\n..." + path.getParent().substring(path.getParent().lastIndexOf("/")) + folder.substring(folder.lastIndexOf("/"));
}

Boolean inCache(String fileName) {
  return cachedImages.contains(fileName);
}

void draw() {
  background(0);
  compareImage(); 
  
  // draw UI
  textAlign(LEFT);
  text(title + "\n\n" + output, 10, 30);
  textAlign(RIGHT);
  text("Moved " + movedCount + " Files:\n" + moveTxt, width - 20, 30);
}

void dispose() {
  writeCacheFile();
}

ArrayList getRandomPixels(int maxPixels) {
  ArrayList ps = new ArrayList();
  int max = min(maxPixels, referenceImage.width * referenceImage.height);

  for (int i = 0; i < max * accuracy; i++) {
    ps.add((int) random(0, max));
  }

  return ps;
}

void writeCacheFile() {
  println("write cache");
  String[] cached = cachedImages.toArray(new String[cachedImages.size()]);
  
  println(cached.length);
  saveStrings(folder + "/" + cacheFileName, cached);
}

void compareImage() {
  output = "";
  
  int imageIndex = (int) random(unprocessedImages.size());
  if (imageIndex >= unprocessedImages.size() || imageIndex <= 0) {
    output = "finished!";
    
    return;
  }

  // get image
  PImage img = loadImage(folder + "/" + unprocessedImages.get(imageIndex));

  // image exists
  if (img == null) {
    return;
  }

  // load
  img.loadPixels();

  // get random pixel positions to compare
  ArrayList<Integer> ps = getRandomPixels(img.width * img.height);
  Boolean sameImage = false;

  // compare
  for (int i = 0; i < ps.size(); i++) {
    if (img.pixels[ps.get(i)] == referenceImage.pixels[ps.get(i)]) {
      sameImage = true;
    }
    else {
      sameImage = false;
      break;
    }
  }

  // move image and delete from list
  if (sameImage) {
    File ff = new File(folder + "/" + unprocessedImages.get(imageIndex));
    ff.renameTo(new File(folder + "/" + defaultImageFolder + "/" + unprocessedImages.get(imageIndex)));

    movedCount++;
    if (movedCount % 7 == 0) {
      moveTxt = "";
    }
    moveTxt += unprocessedImages.get(imageIndex) + "\n";
  }
 
  // add to cache
  cachedImages.add(unprocessedImages.get(imageIndex));
  
  // remove from list
  unprocessedImages.remove(imageIndex);
  
  // update output
  output += unprocessedImages.size() + " files left.\n";
}

