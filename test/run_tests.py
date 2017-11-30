import unittest
import subprocess
import os
from os import stat
from pwd import getpwuid


class TestSRv6(unittest.TestCase):
	def test_sysctl(self):
		ret = subprocess.call(["sysctl", "net.ipv6.conf.all.seg6_enabled"],
		                      stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE)
		self.assertEqual(ret, 0, msg="SRv6 support is not enabled")


class TestIproute2(unittest.TestCase):
	def test_sr_encap(self):
		dev_route = None
		for itf in os.listdir('/sys/class/net/'):
			if itf != 'lo':
				dev_route = itf
				break
		self.assertIsNotNone(dev_route, "Cannot find an interface other than the loopback")
		for mode in ["encap", "inline"]:
			ret = subprocess.call(["ip", "route", "add", "2001:bd8::/64", "encap",
			                       "seg6", "mode", mode, "segs", "2003:db9::1", "dev", dev_route])
			self.assertEqual(ret, 0, msg="iproute2 cannot add SR rules for %s mode" % mode)
			ret = subprocess.call(["ip", "route", "del", "2001:bd8::/64", "encap",
			                       "seg6", "mode", mode, "segs", "2003:db9::1", "dev", dev_route])
			self.assertEqual(ret, 0, msg="iproute2 cannot remove SR rules for %s mode" % mode)


class TestNanonet(unittest.TestCase):
	def test_new_topo(self):
		nanone_wd = "nanonet"
		self.assertTrue(os.path.exists(nanone_wd),
		                msg="Nanonet folder does not exist")
		self.assertEqual(getpwuid(stat(nanone_wd).st_uid).pw_name, "vagrant",
		                 msg="Nanonet does not belong to vagrant user")

		filename = os.path.join(nanone_wd, "example.ntfl")
		with open(filename, "w") as fileobj:
			fileobj.writelines(["A B 1 0.2 100000\n", "A C 1 0.2 100000\n", "B C 1 0.2 100000\n"])
			fileobj.flush()
			topo_filename = os.path.join(nanone_wd, "topos/example.py")
			with open(topo_filename, "w") as topoobj:
				ret = subprocess.call([os.path.join(nanone_wd, "tools/ntfl2topo.sh"),
				                       filename, "Test"], stdout=topoobj)
				self.assertEqual(ret, 0, msg="Cannot create topology python class")
				topoobj.flush()
				ret = subprocess.call([os.path.join(nanone_wd, "build"),
				                       topo_filename, "Test"])
				self.assertEqual(ret, 0, msg="Cannot generate the list of bash commands")
				ret = subprocess.call(["sh", "Test.topo.sh"])
				self.assertEqual(ret, 0, msg="Cannot execute the list of bash commands")
				ret = subprocess.call(["ip", "netns", "exec", "A", "true"])
				self.assertEqual(ret, 0, msg="Cannot enter a network namespace")


suite = unittest.TestSuite([unittest.makeSuite(TestSRv6),
                            unittest.makeSuite(TestIproute2),
                            unittest.makeSuite(TestNanonet)])


if __name__ == '__main__':
	unittest.TextTestRunner(verbosity=2).run(suite)
